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

mkdir -p export/ab
mkdir -p export/wrk

for service in "${services[@]}"; do
  echo "AB Test For: ${service}..."
  file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
  docker-compose run --rm ab -k -c $CONCURRENCY -t $TIME_LIMIT -n 1000000 "http://${service}/hello-world" > "export/ab/${file}"
  echo "WRK Test For: ${service}..."
  docker-compose run --rm wrk -t4 -c $CONCURRENCY -d${TIME_LIMIT}s "http://${service}/hello-world" > "export/wrk/${file}"
done


docker-compose down --remove-orphans

csv_file="export/ab-summary-c-${CONCURRENCY}-t${TIME_LIMIT}s.csv"
echo "service,rps,total" > $csv_file
for service in "${services[@]}"; do
  file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
  rps=$(grep -o 'Requests per second:[[:space:]]*[0-9.]\+' export/ab/${file} | awk '{print $NF}')
  total=$(grep -o 'Complete requests:[[:space:]]*[0-9]\+' export/ab/${file} | awk '{print $NF}')
  echo "${service},${rps},${total}" >> $csv_file
done


csv_file="export/wrk-summary-c-${CONCURRENCY}-t${TIME_LIMIT}s.csv"
echo "service,rps,total" > $csv_file
for service in "${services[@]}"; do
  file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
  rps=$(grep -o 'Requests/sec:[[:space:]]*[0-9.]\+' export/wrk/${file} | awk '{print $NF}')
  total=$(grep -o '[0-9]\+ requests' export/wrk/${file} | awk '{print $1}')
  echo "${service},${rps},${total}" >> $csv_file
done