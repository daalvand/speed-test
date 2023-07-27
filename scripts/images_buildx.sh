#!/bin/bash

DIR="$(dirname "$(dirname "$(readlink -f "$0")")")"
SERVICE_DIR="${DIR}/services"
DOCKER_BUILDKIT=1

docker buildx build -f "$DIR/Dockerfile" "$DIR" -t daalvand/speed-test-base:latest &&
docker buildx build -f "$SERVICE_DIR/pure-php/Dockerfile" "$SERVICE_DIR/pure-php" -t daalvand/speed-test-pure-php:latest &&
docker buildx build -f "$SERVICE_DIR/react-php/Dockerfile" "$SERVICE_DIR/react-php" -t daalvand/speed-test-react-php:latest &&
docker buildx build -f "$SERVICE_DIR/swoole-php/Dockerfile" "$SERVICE_DIR/swoole-php" -t daalvand/speed-test-swoole-php:latest &&
docker buildx build -f "$SERVICE_DIR/yii/Dockerfile" "$SERVICE_DIR/yii" -t daalvand/speed-test-yii:latest &&
docker buildx build -f "$SERVICE_DIR/codeigniter/Dockerfile" "$SERVICE_DIR/codeigniter" -t daalvand/speed-test-codeigniter:latest &&
docker buildx build -f "$SERVICE_DIR/laravel/FPMDockerfile" "$SERVICE_DIR/laravel" -t daalvand/speed-test-laravel:latest &&
docker buildx build -f "$SERVICE_DIR/laravel/SwooleDockerfile" "$SERVICE_DIR/laravel" -t daalvand/speed-test-laravel-octane:latest &&
docker buildx build -f "$SERVICE_DIR/go/Dockerfile" "$SERVICE_DIR/go" -t daalvand/speed-test-go:latest &&
docker buildx build -f "$SERVICE_DIR/fastapi/Dockerfile" "$SERVICE_DIR/fastapi" -t daalvand/speed-test-fastapi:latest &&
docker buildx build -f "$SERVICE_DIR/flask/Dockerfile" "$SERVICE_DIR/flask" -t daalvand/speed-test-flask:latest &&
docker buildx build -f "$SERVICE_DIR/nodejs/Dockerfile" "$SERVICE_DIR/nodejs" -t daalvand/speed-test-nodejs:latest &&
echo 'BUILD DONE!'