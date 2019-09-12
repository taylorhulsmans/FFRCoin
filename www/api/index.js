const app = require('express')();
const http = require('http').Server(app);
const bodyParser = require('body-parser')



http.listen(3000, () => {
	console.log('listening')
})
