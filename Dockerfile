ARG CI_REGISTRY_IMAGE=CHANGEME
FROM ${CI_REGISTRY_IMAGE}:base AS vendor

WORKDIR /app

COPY composer.json composer.json
COPY composer.lock composer.lock

RUN composer install \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --no-dev \
    --prefer-dist

COPY . .
RUN composer dump-autoload

FROM ${CI_REGISTRY_IMAGE}:base

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

COPY . .
COPY --from=vendor /app/vendor/ ./vendor
RUN composer install

RUN find /var/www/html -type f -exec chmod 664 {} \;
RUN find /var/www/html -type d -exec chmod 775 {} \;
RUN chown -Rf www-data: bootstrap storage public


RUN php artisan storage:link
EXPOSE 80
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/conf.d/supervisord.conf"]