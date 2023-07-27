#!/bin/bash

# Set default values for time limit and concurrency
TYPE="${1:-ab}"
TIME_LIMIT="${2:-10}"
CONCURRENCY="${3:-100}"

docker-compose down --remove-orphans

# Build
docker-compose build && docker-compose build ab && docker-compose up -d

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

for service in "${services[@]}"; do
  echo "AB Test For: ${service}..."
  file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
  docker-compose run --rm ab -k -c $CONCURRENCY -t $TIME_LIMIT -n 1000000 "http://${service}/hello-world" >"export/ab/${file}"
done

docker-compose down --remove-orphans

csv_file="export/ab-summary-c-${CONCURRENCY}-t${TIME_LIMIT}s.csv"
echo "service,rps,total" >$csv_file
for service in "${services[@]}"; do
  file=${service}-hw-c-${CONCURRENCY}-t${TIME_LIMIT}s.txt
  rps=$(grep -o 'Requests per second:[[:space:]]*[0-9.]\+' export/ab/${file} | awk '{print $NF}')
  total=$(grep -o 'Complete requests:[[:space:]]*[0-9]\+' export/ab/${file} | awk '{print $NF}')
  echo "${service},${rps},${total}" >>$csv_file
done
