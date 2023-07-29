#!/bin/bash

# Set default values for time limit and concurrency
CONCURRENCY="${1:-100}"
TOTAL_COUNT="${2:-10000}"

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

mkdir -p export/hey

for service in "${services[@]}"; do
  echo "HEY Test For: ${service}..."
  file=${service}-hw-c-${CONCURRENCY}-n-${TOTAL_COUNT}.txt
  docker-compose run --rm base hey -n $TOTAL_COUNT -c $CONCURRENCY -m GET "http://${service}/hello-world" >"export/hey/${file}"
  docker-compose kill -s SIGKILL $service
done

docker-compose down --remove-orphans

csv_file="export/hey-summary-c-${CONCURRENCY}-n${TOTAL_COUNT}.csv"
echo "service,rps" > $csv_file
for service in "${services[@]}"; do
  file=${service}-hw-c-${CONCURRENCY}-n-${TOTAL_COUNT}.txt
  rps=$(grep -o 'Requests/sec:[[:space:]]*[0-9.]\+' export/hey/${file} | awk '{print $NF}')
  echo "${service},${rps}" >>$csv_file
done
