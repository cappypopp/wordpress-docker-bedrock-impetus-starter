# Use PHP base image
FROM node:18

# Install PHP and Composer dependencies
RUN apt-get update && apt-get install -y \
    php php-cli php-zip php-mbstring php-xml \
    php-curl php-gd php-intl php-mysql git unzip curl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ARG WP_THEME_NAME
ARG SAGE_VERSION
ENV WP_THEME_NAME=${WP_THEME_NAME}
ENV SAGE_VERSION=${SAGE_VERSION}

RUN echo "Installing Sage to themes/$WP_THEME_NAME" \
    && composer create-project roots/sage /var/www/html/web/app/themes/$WP_THEME_NAME $SAGE_VERSION
# Set working directory
WORKDIR /var/www/html/web/app/themes/${WP_THEME_NAME}

COPY ./vite.config.js ./vite.config.js
COPY ./eslint.config.js ./eslint.config.js

# dont need to run composer install here because it's already done by the create-project command
# RUN composer install
RUN npm install

# Default command
# CMD ["php-fpm"] # Do not need this because we have an entrypoint and don't want to run a PHP-FPM server
