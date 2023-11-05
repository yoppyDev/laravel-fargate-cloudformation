ARG AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID}
ARG PJPrefix=${PJPrefix}

FROM ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/${PJPrefix}/base-nginx:latest

WORKDIR /application

# TODO: 本来はsrcと環境構築用とSRCを分けようと考えている
# g clone 

COPY ./src /application

RUN cd /application

RUN cp .env.example .env

RUN composer install
RUN php artisan cache:clear \
    && php artisan config:clear \
    && php artisan route:clear \
    && php artisan view:clear
RUN chown -R www-data:www-data storage

RUN npm install
RUN npm run build
