const path = require('path')
const express = require('express')
const router = express.Router()

import * as FiatFrenzy from '../abi/FiatFrenzy.json'
//accounts
module.exports = (web3) => {
	router.get('/', async (req, res) => {
		let address = process.env.CONTRACT_ADDRESS
		
		return res.json({
				address,
				FiatFrenzy
		})
	})

	return router
}
