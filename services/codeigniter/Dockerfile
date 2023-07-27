FROM php:8.2-fpm-alpine

RUN apk update

## install extentions
RUN apk add --no-cache icu-dev
RUN docker-php-ext-install intl

WORKDIR /app
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . .

RUN composer install -o --no-dev

EXPOSE 80 9000

CMD [ "php", "spark", "serve", "--host", "0.0.0.0", "--port", "80" ]


