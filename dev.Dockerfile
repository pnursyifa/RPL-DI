# FROM php:7.4.33-fpm-alpine
FROM php:8.1.2-fpm-alpine

# ENV Timezone
ENV TZ="Asia/Jakarta"

# Installing Dependencies
RUN apk add --no-cache tzdata $PHPIZE_DEPS \
    zip unzip curl nginx supervisor git

# Enable PHP GD PNG JPEG WEBP Freetype Support
RUN apk add --no-cache zlib libpng-dev libwebp-dev jpeg-dev libjpeg-turbo-dev freetype-dev
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp

# Install PHP Dependencies
RUN apk add --no-cache oniguruma-dev libzip-dev

# Install PHP Extensions
RUN docker-php-ext-install pdo mbstring exif pcntl bcmath gd zip

# Install PHP Database Dependencies
RUN docker-php-ext-install pdo_mysql mysqli

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# SETUP PHP-FPM CONFIG SETTINGS (max_children / max_requests)
RUN echo 'pm.max_children = 5' >> /usr/local/etc/php-fpm.d/zz-docker.conf && \
    echo 'pm.start_servers = 3' >> /usr/local/etc/php-fpm.d/zz-docker.conf && \
    echo 'pm.min_spare_servers = 2' >> /usr/local/etc/php-fpm.d/zz-docker.conf && \
    echo 'pm.max_spare_servers = 4' >> /usr/local/etc/php-fpm.d/zz-docker.conf

# Copy configs
COPY ./docker/php-custom-setting.ini /usr/local/etc/php/conf.d/
COPY ./docker/supervisor.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./docker/nginx.conf /etc/nginx/nginx.conf

# Set working directory
WORKDIR /var/www

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/conf.d/supervisord.conf"]
