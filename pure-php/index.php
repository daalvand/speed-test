<?php
// Define the routing logic
function route($path): string
{
    $path = trim($path, '/ ');
    return match ($path) {
        'hello-world'  => 'Hello World',
        default        => '404 - Not Found',
    };
}


$requestPath = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

echo route($requestPath);