FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libjpeg-dev libfreetype6-dev mariadb-client less nano curl \
    && docker-php-ext-configure zip \
    && docker-php-ext-install pdo_mysql mysqli zip gd

# Install Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# create cache directory for composer, this is mapped to the anonymous volume in docker-compose.yml
RUN mkdir /var/cache/composer
ENV COMPOSER_HOME=/var/cache/composer

# Install Composer from the latest image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Composer dependencies with verbose output
RUN composer update -vvv

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html
