const express = require('express')
const router = express.Router()
import axios from 'axios'
import * as FiatFrenzy from '../abi/FiatFrenzy.json'

async function mint(web3, addr, thread, post) {
  const contract = new web3.eth.contract(FiatFrenzy, process.env.CONTRACT_ADDRESS)
  const mint = this.contract.methods.proofOfMeme(addr, thread, post);
  const encoded = mint.encodeABI()
  const signedTx = await web3.eth.accounts.signTransaction(
    {
      data: encoded,
      from: process.env.MINT_ADDRESS,
      gas: 100000,
      to: contract.options.address,
    },
    process.env.MINT_PK,
    false,
  )
  return web3.eth.sendSignedTransaction(signedTx.rawTransaction)
}

module.exports = (web3) => {
  router.post('/', async (req, res) => {
    try {
      const chRes = await axios.get(`https://a.4cdn.org/pol/thread/${req.body.thread}.json`)
    } catch (e) {
      res.json({message: 'error'})
      return
    }

    let post = chRes.data.posts.find((post) => {
      return post.no == req.body.post
    })
    if (post) {
      let addr = post.com.search(/^0x[a-zA-Z0-9]+/)
      if (addr) {
        try {
          const mint = await mint(web3, addr, req.body.thread, req.body.post)
        } catch (e) {
          return e
        }
      }
      
    } else {
      res.json({
        message: 'no post by this number'
      })
      return
    }
    res.json({
      message: '',
      data: {
      }
    })
  })

  return router
}
