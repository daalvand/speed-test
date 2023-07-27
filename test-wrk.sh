#!/bin/bash

# Set default values for time limit and concurrency
TIME_LIMIT="${2:-10}"
CONCURRENCY="${3:-100}"

docker-compose down --remove-orphans

# Build
docker-compose build && docker-compose build wrk && docker-compose up -d

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

mkdir -p export/wrk

for service in "${services[@]}"; do
  echo "WRK Test For: ${service}..."
  file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
  docker-compose run --rm wrk -t4 -c $CONCURRENCY -d${TIME_LIMIT}s "http://${service}/hello-world" >"export/wrk/${file}"
done

docker-compose down --remove-orphans

csv_file="export/wrk-summary-c-${CONCURRENCY}-t${TIME_LIMIT}s.csv"
echo "service,rps,total" >$csv_file
for service in "${services[@]}"; do
  file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
  rps=$(grep -o 'Requests/sec:[[:space:]]*[0-9.]\+' export/wrk/${file} | awk '{print $NF}')
  total=$(grep -o '[0-9]\+ requests' export/wrk/${file} | awk '{print $1}')
  echo "${service},${rps},${total}" >>$csv_file
done
