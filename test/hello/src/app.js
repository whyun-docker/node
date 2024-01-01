require('xprofiler').start();
const slogger = require('node-slogger');
const http = require('http');
const { sign } = require('./jose.test');
const TIMEOUT_SERVER = 1000 * 60 * 30;
const ENV = process.env;
const server = http.createServer((req, res) => {
    res.writeHead(200);
    res.end('hello world ' + sign + '\n');
    slogger.info(`${req.url} 200`);    
}).listen(ENV.APP_PORT || 8000, ENV.LISTEN_ADDR);
server.timeout = TIMEOUT_SERVER;
server.keepAliveTimeout = TIMEOUT_SERVER;

slogger.info(`Worker ${process.pid} started`);