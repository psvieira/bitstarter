var express = require('express');
var fs = require('fs');
var inFile = 'index.html'
var inBuffer = new Buffer(255);

var app = express.createServer(express.logger());

app.get('/', function(request, response) {
	inBuffer = fs.readFileSync(inFile);
	response.send(inBuffer.toString());
});

var port = process.env.PORT || 8080;
app.listen(port, function() {
  console.log("Listening on " + port);
});