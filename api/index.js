require('dotenv').config()
const app = require('express')();
const http = require('http').Server(app);
const bodyParser = require('body-parser');
const mintRouter = require('./routers/mint');
const contractRouter = require('./routers/contract')
import Web3 from 'web3'
let web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));
web3 = new Web3(web3.currentProvider)
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))
app.use('/api/mint', mintRouter(web3));
app.use('/api/contract', contractRouter(web3));

http.listen(3000, () => {
	console.log('listening')
})
