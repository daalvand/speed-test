#!/bin/bash

# Set default values for time limit and concurrency
TYPE="${1:-ab}"
TIME_LIMIT="${2:-10}"
CONCURRENCY="${3:-100}"

docker-compose down --remove-orphans

# Build
docker-compose build &&
  docker-compose build ab wrk &&
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

mkdir -p export/ab
mkdir -p export/wrk
mkdir -p export/hey

if [ $TYPE == "ab" ]; then
  for service in "${services[@]}"; do
    echo "AB Test For: ${service}..."
    file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
    docker-compose run --rm ab -k -c $CONCURRENCY -t $TIME_LIMIT -n 1000000 "http://${service}/hello-world" > "export/ab/${file}"
  done
fi

if [ $TYPE == "hey" ]; then
  for service in "${services[@]}"; do
    echo "HEY Test For: ${service}..."
    file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
    docker-compose run --rm hey -n 100000 -c $CONCURRENCY -t $TIME_LIMIT -m GET "http://${service}/hello-world" > "export/hey/${file}"
  done
fi

if [ $TYPE == "wrk" ]; then
  for service in "${services[@]}"; do
    echo "WRK Test For: ${service}..."
    file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
    docker-compose run --rm wrk -t4 -c $CONCURRENCY -d${TIME_LIMIT}s "http://${service}/hello-world" > "export/wrk/${file}"
  done
fi

docker-compose down --remove-orphans

if [ $TYPE == "ab" ]; then
  csv_file="export/ab-summary-c-${CONCURRENCY}-t${TIME_LIMIT}s.csv"
  echo "service,rps,total" >$csv_file
  for service in "${services[@]}"; do
    file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
    rps=$(grep -o 'Requests per second:[[:space:]]*[0-9.]\+' export/ab/${file} | awk '{print $NF}')
    total=$(grep -o 'Complete requests:[[:space:]]*[0-9]\+' export/ab/${file} | awk '{print $NF}')
    echo "${service},${rps},${total}" >>$csv_file
  done
fi

if [ $TYPE == "wrk" ]; then
  csv_file="export/wrk-summary-c-${CONCURRENCY}-t${TIME_LIMIT}s.csv"
  echo "service,rps,total" >$csv_file
  for service in "${services[@]}"; do
    file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
    rps=$(grep -o 'Requests/sec:[[:space:]]*[0-9.]\+' export/wrk/${file} | awk '{print $NF}')
    total=$(grep -o '[0-9]\+ requests' export/wrk/${file} | awk '{print $1}')
    echo "${service},${rps},${total}" >>$csv_file
  done
fi
