const app = require('express')();
const http = require('http').Server(app);
const bodyParser = require('body-parser')

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))


http.listen(3000, () => {
	console.log('listening')
})
