const app = require('express')();
const http = require('http').Server(app);
const bodyParser = require('body-parser');
const mintRouter = require('./routers/mint');
import Web3 from 'web3'
const web3 = new Web3('ws://localhost:8546');
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))
app.use('/api/mint', mintRouter(web3));

http.listen(3000, () => {
	console.log('listening')
})
