<?php

use Swoole\Http\Server;
use Swoole\Http\Request;
use Swoole\Http\Response;


$server = new Swoole\HTTP\Server('0.0.0.0', '80', true);

$server->on("start", function (Server $server) {
    echo "Swoole http server is started at {0.0.0.0}:{80}\n";
});

$server->on("request", function (Request $request, Response $response) {
    $response->header("Content-Type", "text/plain");
    $uri = trim($request->server['request_uri'], '/');
    if ($uri === 'hello-world') {
        return $response->end("Hello World");
    }
    return $response->end("Not Found");
});

$server->start();