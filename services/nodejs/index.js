const http = require('http');

http.createServer(function (req, res) {
    const url = removeSlashes(req.url);
    if (url === 'hello-world') {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.end('Hello World');
    } else {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.end('Not Found!')
    }

}).listen(80, '0.0.0.0');

function removeSlashes(str) {
    return str.replace(/^\/+|\/+$/g, '');
}