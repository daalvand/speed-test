FROM php:8.2-fpm-alpine

WORKDIR /app
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . .

RUN composer install -o --no-dev

EXPOSE 80 9000

CMD [ "php", "yii", "serve", "0.0.0.0", "--port=80" ]
