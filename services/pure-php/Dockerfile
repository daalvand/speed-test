FROM richarvey/nginx-php-fpm

ENV SKIP_COMPOSER=true

WORKDIR "/var/www/html"

RUN sed -i -e "s|try_files \$uri \$uri/ =404;|try_files \$uri \$uri/ /index.php\$is_args\$args;|g" /etc/nginx/sites-available/default.conf \
    && sed -i -e "s|try_files \$uri \$uri/ =404;|try_files \$uri \$uri/ /index.php\$is_args\$args;|g" /etc/nginx/sites-available/default-ssl.conf

# Replace the PHP-FPM configurations using sed
RUN sed -i 's/^pm.max_children = .*/pm.max_children = 1000/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^pm.start_servers = .*/pm.start_servers = 100/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^pm.min_spare_servers = .*/pm.min_spare_servers = 50/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^pm.max_spare_servers = .*/pm.max_spare_servers = 200/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^pm.max_requests = .*/pm.max_requests = 1000/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^request_terminate_timeout = .*/request_terminate_timeout = 30s/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^pm.process_idle_timeout = .*/pm.process_idle_timeout = 10s/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^pm.status_path = .*/pm.status_path = \/status/' /usr/local/etc/php-fpm.d/www.conf

COPY ./index.php .
