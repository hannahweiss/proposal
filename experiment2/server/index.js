const express = require("express");
const http = require('http');
const path = require('path');
const app = express();
const server = http.createServer(app);
const { ExpressPeerServer } = require('peer');
const port = 4000;

let users = []

const peerServer = ExpressPeerServer(server, {
    proxied: true,
    debug: true,
    path: '/myapp',
    ssl: {}
});

// TODO: install cors middleware
app.use(peerServer);


// GET /connect/id
app.get('/connect/:id', (req, res) => {
    id = req.params["id"]
    let prev = [...users]
    users.push(id)
    res.header("Access-Control-Allow-Origin", "*");
    res.send(prev)
})


server.listen(port);
console.log('Listening on: ' + port);
