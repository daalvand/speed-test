#!/bin/bash

# Set default values for time limit and concurrency
TIME_LIMIT="${1:-10}"
CONCURRENCY="${2:-100}"

docker-compose down --remove-orphans

# Build
docker-compose build &&
  docker-compose build ab wrk &&

  # Dependency installation
  docker-compose run --rm nodejs npm install &&
  docker-compose run --rm react-php composer install -o &&
  cp laravel/.env.example laravel/.env &&
  docker-compose run --rm laravel composer install -o &&
  docker-compose run --rm laravel php artisan key:generate &&
  docker-compose run --rm laravel php artisan optimize &&
  docker-compose run --rm yii composer install -o &&
  docker-compose run --rm flask python -m venv /app/venv &&
  docker-compose run --rm flask pip install -r requirements.txt &&
  docker-compose run --rm fastapi python -m venv /app/venv &&
  docker-compose run --rm fastapi pip install -r requirements.txt &&
  docker-compose up -d

sleep 10

services=(
  fastapi
  flask
  go
  laravel
  laravel-octane
  nodejs
  pure-php
  react-php
  swoole-php
  yii
)

for service in "${services[@]}"; do
  echo "AB Test For: ${service}..."
  docker-compose run --rm ab -k -c $CONCURRENCY -t $TIME_LIMIT "http://${service}/hello-world" >"results/ab-${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt"
  echo "WRK Test For: ${service}..."
  docker-compose run --rm wrk -t4 -c $CONCURRENCY -d${TIME_LIMIT}s "http://${service}/hello-world" >"results/wrk-${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt"
done

docker-compose down --remove-orphans
