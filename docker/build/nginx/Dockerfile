ARG AWS_ACCOUNT=${AWS_ACCOUNT}

FROM $AWS_ACCOUNT.dkr.ecr.ap-northeast-1.amazonaws.com/nginx:latest

COPY ./src /application

RUN cd /application \
 && cp .env.example .env \
 && npm install \
 && npm build
