#!/bin/bash

# Set default values for time limit and concurrency
CONCURRENCY="${1:-100}"
TOTAL_COUNT="${2:-10000}"

docker-compose down --remove-orphans

# Build
docker-compose build &&
  docker-compose build hey &&
  # Dependency installation
  docker-compose run --rm nodejs npm install &&
  docker-compose run --rm react-php composer install -o &&
  docker-compose run --rm laravel cp .env.example .env &&
  docker-compose run --rm laravel composer install -o &&
  docker-compose run --rm laravel php artisan key:generate &&
  docker-compose run --rm laravel php artisan optimize &&
  docker-compose run --rm codeigniter composer install -o &&
  docker-compose run --rm yii composer install -o &&
  docker-compose run --rm flask python -m venv /app/venv &&
  docker-compose run --rm flask pip install -r requirements.txt &&
  docker-compose run --rm fastapi python -m venv /app/venv &&
  docker-compose run --rm fastapi pip install -r requirements.txt &&
  docker-compose up -d

sleep 10

services=(
  codeigniter
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

mkdir -p export/hey

for service in "${services[@]}"; do
  echo "HEY Test For: ${service}..."
  file=${service}-hw-c-${CONCURRENCY}-n-${TOTAL_COUNT}.txt
  docker-compose run --rm hey -n $TOTAL_COUNT -c $CONCURRENCY -m GET "http://${service}/hello-world" >"export/hey/${file}"
done

docker-compose down --remove-orphans

csv_file="export/hey-summary-c-${CONCURRENCY}-n${TOTAL_COUNT}.csv"
echo "service,rps" > $csv_file
for service in "${services[@]}"; do
  file=${service}-hw-c-${CONCURRENCY}-n${TOTAL_COUNT}.txt
  rps=$(grep -o 'Requests/sec:[[:space:]]*[0-9.]\+' export/hey/${file} | awk '{print $NF}')
  echo "${service},${rps}" >>$csv_file
done
