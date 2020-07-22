/*
Websocket based Chat Server
Before you run this app first execute
>npm install
to install npm modules dependencies listed in package.json file

Then launch this server:
node app.js

Then open several browsers to: http://localhost:3000/index.html

*/

const http = require('http')
//npm modules (need to install these first)
const WebSocketServer = require('ws').Server //provides web sockets
const ecStatic = require('ecstatic')  //provides convenient static file server service

//static file server based on npm module ecstatic
var server = http.createServer(ecStatic({root: __dirname + '/www'}))

var wss = new WebSocketServer({server: server})
wss.on('connection', function(ws) {
  console.log('Client connected')
  ws.on('message', function(msg) {
    console.log('Message: ' + msg)
    broadcast(msg)
  })
  ws.send('Connected to Server')
})

function broadcast(msg) {
  //send msg to all connected client sockets
  wss.clients.forEach(function(client) {
    client.send(msg)
  })
}

server.listen(3000);
console.log('Server listening on port 3000.  CNTL-C to quit');
console.log('To Test: open several browsers to: http://localhost:3000/index.html')
