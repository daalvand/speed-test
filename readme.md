# ReactPHP vs Swoole vs Pure PHP vs NodeJs vs GO

## Run Hello World

### build 
```shell
docker-compose build
```

### install dependencies
```shell
docker-compose run --rm nodejs npm install 
docker-compose run --rm react-php composer install
cp laravel/.env.example laravel/.env
docker-compose run --rm laravel composer install
docker-compose run --rm laravel php artisan key:generate
```

### start services
```shell
docker-compose up -d
```

## requests
```shell
#hello world
docker-compose run --rm ab -k -c 100 -n 100000 http://swoole-php/hello-world > results/ab-swoole-php-hw-c-100-n-100000.txt
docker-compose run --rm ab -k -c 100 -n 100000 http://pure-php/hello-world > results/ab-pure-php-hw-c-100-n-100000.txt
docker-compose run --rm ab -k -c 100 -n 100000 http://react-php/hello-world > results/ab-react-php-hw-c-100-n-100000.txt
docker-compose run --rm ab -k -c 100 -n 100000 http://laravel/hello-world > results/ab-laravel-hw-c-100-n-100000.txt
docker-compose run --rm ab -k -c 100 -n 100000 http://laravel-octane/hello-world > results/ab-laravel-octane-hw-c-100-n-100000.txt
docker-compose run --rm ab -k -c 100 -n 100000 http://nodejs/hello-world > results/ab-nodejs-hw-c-100-n-100000.txt
docker-compose run --rm ab -k -c 100 -n 100000 http://go/hello-world > results/ab-go-hw-c-100-n-100000.txt


docker-compose run --rm wrk -t4 -c100 -d20s --latency http://swoole-php/hello-world > results/wrk-swoole-php-hw-c-100-d20s.txt
docker-compose run --rm wrk -t4 -c100 -d20s --latency http://pure-php/hello-world > results/wrk-pure-php-hw-c-100-d20s.txt
docker-compose run --rm wrk -t4 -c100 -d20s --latency http://react-php/hello-world > results/wrk-react-php-hw-c-100-d20s.txt
docker-compose run --rm wrk -t4 -c100 -d20s --latency http://laravel/hello-world > results/wrk-laravel-hw-c-100-d20s.txt
docker-compose run --rm wrk -t4 -c100 -d20s --latency http://laravel-octane/hello-world > results/wrk-laravel-octane-hw-c-100-d20s.txt
docker-compose run --rm wrk -t4 -c100 -d20s --latency http://nodejs/hello-world > results/wrk-nodejs-hw-c-100-d20s.txt
docker-compose run --rm wrk -t4 -c100 -d20s --latency http://go/hello-world > results/wrk-go-hw-c-100-d20s.txt
```

## result

### Apache Bench:

![bar-graph.png](results/image-apache-bench-result.png)

### Wrk Result:

![wrk-result.png](results/image-wrk-result.png)