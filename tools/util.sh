#!/bin/sh

set -u
. "$(cd "$(dirname "$0")/../" && pwd)/.env"

createProject()
{
    docker build --platform=linux/amd64 \
        -t composer:latest \
        -f ./docker/composer/Dockerfile .

    docker run -v $(pwd):/application composer:latest composer create-project --prefer-dist laravel/laravel src
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

build()
{
    docker build --platform=linux/amd64 \
        -t ${PJPrefix}/laravel:latest \
        -f ./docker/laravel/Dockerfile .

    docker build --platform=linux/amd64 \
        -t ${PJPrefix}/nginx:latest \
        -f ./docker/nginx/Dockerfile .
}

push()
{
    docker tag ${PJPrefix}/laravel:latest \
        ${REGISTRY_URL}/${PJPrefix}/laravel:latest

    docker tag ${PJPrefix}/nginx:latest \
        ${REGISTRY_URL}/${PJPrefix}/nginx:latest

    docker push ${REGISTRY_URL}/${PJPrefix}/laravel:latest
    docker push ${REGISTRY_URL}/${PJPrefix}/nginx:latest
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

batch()
{
 aws ecs run-task \
    --cluster ${PJPrefix}-cluster \
    --task-definition ${PJPrefix}-batch-run-task \
    --overrides '{"containerOverrides": [{"name":"laravel","command": ["sh","-c","php artisan -v"]}]}' \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[${SUBNET_1}],securityGroups=[${SECURITY_GROUP}],assignPublicIp=ENABLED}" \
    --region ${REGIN} \
    --profile ${AWS_PROFILE}
}


$1 "${2:-""}"
exit 0
