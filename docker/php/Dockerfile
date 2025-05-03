FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libjpeg-dev libfreetype6-dev mariadb-client less nano curl \
    && docker-php-ext-configure zip \
    && docker-php-ext-install pdo_mysql mysqli zip gd

# Install Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug


COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

RUN ls -al

# Update composer dependencies at runtime
COPY ./php-entrypoint.sh /usr/local/bin/php-entrypoint.sh
ENTRYPOINT ["php-entrypoint.sh"]
