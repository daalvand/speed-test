#!/bin/bash

#push
docker push daalvand/speed-test-base:latest &&
docker push daalvand/speed-test-pure-php:latest &&
docker push daalvand/speed-test-react-php:latest &&
docker push daalvand/speed-test-swoole-php:latest &&
docker push daalvand/speed-test-yii:latest &&
docker push daalvand/speed-test-codeigniter:latest &&
docker push daalvand/speed-test-laravel:latest &&
docker push daalvand/speed-test-laravel-octane:latest &&
docker push daalvand/speed-test-go:latest &&
docker push daalvand/speed-test-fastapi:latest &&
docker push daalvand/speed-test-flask:latest &&
docker push daalvand/speed-test-nodejs:latest &&
echo 'PUSH DONE!'