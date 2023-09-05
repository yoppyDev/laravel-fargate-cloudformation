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
    aws s3api create-bucket --bucket ${S3_BUCKET} --region ap-northeast-1 --create-bucket-configuration LocationConstraint=ap-northeast-1
}

createEcr()
{
    aws ecr create-repository --repository-name laravel --region ap-northeast-1
    aws ecr create-repository --repository-name nginx --region ap-northeast-1
}

build()
{
    docker build --platform=linux/amd64 \
        -t laravel:latest \
        -f ./docker/laravel/Dockerfile .

    docker build --platform=linux/amd64 \
        -t nginx:latest \
        -f ./docker/nginx/Dockerfile .
}

push()
{
    docker tag laravel:latest \
        ${REGISTRY_URL}/laravel:latest

    docker tag nginx:latest \
        ${REGISTRY_URL}/nginx:latest

    docker push ${REGISTRY_URL}/laravel:latest
    docker push ${REGISTRY_URL}/nginx:latest
}

deploy()
{
    aws cloudformation package \
        --template-file ./cloudformation/main.yml \
        --s3-bucket ${S3_BUCKET} \
        --output-template-file ./cloudformation/output/main-stack.yml

    rain deploy ./cloudformation/output/main-stack.yml laravel-templete
}

batch()
{
 aws ecs run-task \
    --cluster ${PJPrefix}-cluster \
    --task-definition ${PJPrefix}-batch-run-task \
    --overrides '{"containerOverrides": [{"name":"laravel","command": ["sh","-c","php artisan -v"]}]}' \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[${SUBNET_1}],securityGroups=[${SECURITY_GROUP}],assignPublicIp=ENABLED}"
}


$1 "${2:-""}"
exit 0
