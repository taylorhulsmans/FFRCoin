const express = require('express')
const router = express.Router()
//accounts/
module.exports = (web3) => {
	router.get('/', async (req, res) => {
		const loans = [];
		
		
		res.json({
			message: '',
			data: {
				loans,
			}
		})
	})

	return router
}
