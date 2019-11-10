const express = require('express')
const router = express.Router()
import axios from 'axios'
//accounts/
module.exports = (web3) => {
  router.post('/', async (req, res) => {
    

    res.json({
      message: '',
      data: {
      }
    })
  })

  return router
}
