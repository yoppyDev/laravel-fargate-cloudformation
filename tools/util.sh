#!/bin/sh

set -u
. "$(cd "$(dirname "$0")/../" && pwd)/.env"

createProject()
{
    docker build --platform=linux/amd64 \
        -t composer:latest \
        -f ./docker/base/composer/Dockerfile .

    docker run -v $(pwd):/application composer:latest composer create-project --prefer-dist "laravel/laravel=10.*" src
}

createBucket()
{
    aws s3api create-bucket --bucket ${PJPrefix} --region ${REGIN} --create-bucket-configuration LocationConstraint=${REGIN} --profile ${AWS_PROFILE}
}

createEcr()
{
    aws ecr create-repository --repository-name ${PJPrefix}/laravel --region ${REGIN} --profile ${AWS_PROFILE}
    aws ecr create-repository --repository-name ${PJPrefix}/nginx --region ${REGIN} --profile ${AWS_PROFILE}
}

createSystemParameter()
{
    aws ssm put-parameter --name "/${PJPrefix}/APP_KEY" --value "${APP_KEY}" --type String --region ${REGIN} --profile ${AWS_PROFILE}
    aws ssm put-parameter --name "/${PJPrefix}/database" --value "${DATABASE}" --type String --region ${REGIN} --profile ${AWS_PROFILE}
    aws ssm put-parameter --name "/${PJPrefix}/master/username" --value "${DB_USERNAME}" --type String --region ${REGIN} --profile ${AWS_PROFILE}
    aws ssm put-parameter --name "/${PJPrefix}/master/password" --value "${DB_PASSWORD}" --type String --region ${REGIN} --profile ${AWS_PROFILE}
}


baseBuild()
{
    docker build --platform=linux/amd64 \
        -t ${PJPrefix}/base-nginx:latest \
        -f ./docker/base/nginx/Dockerfile .
}

basePush()
{
    docker tag ${PJPrefix}/base-nginx:latest \
        ${REGISTRY_URL}/${PJPrefix}/base-nginx:latest

    docker push ${REGISTRY_URL}/${PJPrefix}/base-nginx:latest
}

build()
{
    docker build --platform=linux/amd64 \
        --build-arg AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID} \
        --build-arg PJPrefix=${PJPrefix} \
        -t ${PJPrefix}/build-nginx:latest \
        -f ./docker/build/nginx/Dockerfile .
}

push()
{
    docker tag ${PJPrefix}/build-nginx:latest \
        ${REGISTRY_URL}/${PJPrefix}/build-nginx:latest

    docker push ${REGISTRY_URL}/${PJPrefix}/build-nginx:latest
}

deploy()
{
    aws cloudformation package \
        --template-file ./cloudformation/main.yml \
        --s3-bucket ${PJPrefix} \
        --output-template-file ./cloudformation/output/main-stack.yml \
        --profile ${AWS_PROFILE} \
        --region ${REGIN}

    rain deploy ./cloudformation/output/main-stack.yml ${PJPrefix} --profile ${AWS_PROFILE}
}

subDeploy()
{
    aws cloudformation package \
        --template-file ./cloudformation-v2/main.yml \
        --s3-bucket ${PJPrefix} \
        --output-template-file ./cloudformation-v2/output/main-stack.yml \
        --profile ${AWS_PROFILE} \
        --region ${REGIN}

    rain deploy ./cloudformation-v2/output/main-stack.yml ${PJPrefix} --profile ${AWS_PROFILE}
}

updateService()
{
    aws ecs update-service \
        --cluster ${PJPrefix}-cluster \
        --service ${PJPrefix}-service \
        --task-definition ${PJPrefix}-run-web-task \
        --force-new-deployment
}


$1 "${2:-""}"
exit 0
