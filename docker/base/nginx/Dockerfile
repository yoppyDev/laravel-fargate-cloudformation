ARG NODE_VERSION=18.*

FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libicu-dev \
    supervisor \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# mysql setting
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo_mysql

# Install Node
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -
RUN apt-get install -y nodejs
RUN apt-get install nodejs npm -y

# nginx setting
RUN apt-get install -y nginx
COPY ./docker/base/nginx/conf.d/default.conf /etc/nginx/conf.d/
ADD ./docker/base/nginx/conf.d/nginx.conf /etc/nginx/

COPY ./docker/base/nginx/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
COPY ./docker/base/nginx/conf.d/supervisord.conf /etc/supervisor/supervisord.conf

ENV TZ=Asia/Tokyo

EXPOSE 80
