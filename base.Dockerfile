FROM php:8.3.2-fpm-alpine

# ENV Timezone
ENV TZ="Asia/Jakarta"

# Installing Dependencies
RUN apk add --no-cache tzdata $PHPIZE_DEPS \
  zip unzip curl nginx supervisor

# Enable PHP GD PNG JPEG WEBP Freetype Support
RUN apk add --no-cache zlib libpng-dev libwebp-dev jpeg-dev libjpeg-turbo-dev freetype-dev
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp

# Install PHP Dependencies
RUN apk add --no-cache oniguruma-dev libzip-dev

# Install PHP Extensions
RUN docker-php-ext-install pdo mbstring exif pcntl bcmath gd zip

# Install PHP Database Dependencies
# PGSQL
RUN apk add --no-cache postgresql-dev
RUN docker-php-ext-install pdo_pgsql

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www
