#!/bin/bash

# Set default values for time limit and concurrency
TIME_LIMIT="${1:-10}"
CONCURRENCY="${2:-100}"

DIR="$(dirname "$(dirname "$(readlink -f "$0")")")"

cd $DIR

docker-compose down --remove-orphans

# Build
docker-compose build base && docker-compose up -d

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
  docker-compose run --rm base ab -k -c $CONCURRENCY -t $TIME_LIMIT -n 1000000 "http://${service}/hello-world" > "export/ab/${file}"
  docker-compose kill -s SIGKILL $service
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
