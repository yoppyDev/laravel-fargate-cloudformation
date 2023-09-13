FROM php:8.2-fpm
COPY ./src /application
WORKDIR /application
COPY --from=composer /usr/local/bin/composer /usr/local/bin/composer
RUN apt-get update && apt-get install -y \
        git \
        zip \
        unzip \
        libicu-dev

RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo_mysql

RUN composer install
RUN php artisan cache:clear \
    && php artisan config:clear \
    && php artisan route:clear \
    && php artisan view:clear
RUN chown -R www-data:www-data storage
