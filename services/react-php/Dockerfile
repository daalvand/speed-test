FROM php:8.2-fpm-alpine

ENV SKIP_COMPOSER=true

WORKDIR /app
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . .

RUN composer install -o --no-dev

EXPOSE 80

CMD [ "php", "index.php" ]