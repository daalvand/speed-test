<?php

require __DIR__ . '/vendor/autoload.php';

use Psr\Http\Message\ServerRequestInterface;
use React\Http\HttpServer;
use React\Http\Message\Response;

$http = new HttpServer(function (ServerRequestInterface $request) {
    $parsedUrl = parse_url($request->getUri());
    $uri = trim($parsedUrl['path'], '/ ');
    if ($uri === 'hello-world') {
        return new Response(200, ['Content-Type' => 'text/plain'], "Hello World!");
    }
    return new Response(200, ['Content-Type' => 'text/plain'], "not found!");
});

$socket = new React\Socket\SocketServer('0.0.0.0:80');
$http->listen($socket);