const express = require('express')
const router = express.Router()
import axios from 'axios'
import * as FiatFrenzy from '../abi/FiatFrenzy.json'
async function mint(web3, addr, thread, post) {
  try {
    const contract = new web3.eth.Contract(FiatFrenzy.abi, process.env.CONTRACT_ADDRESS)
    let accounts = await web3.eth.getAccounts()
    return await contract.methods.proofOfMeme(addr, post).send({from:accounts[0], gas: 5000000});
  } catch (e) {
    console.log(e)
    return e
  }
}

module.exports = (web3) => {
  router.post('/', async (req, res) => {
    let chRes = null;
    try {
      chRes = await axios.get(`https://a.4cdn.org/pol/thread/${req.body.thread}.json`)
      
    } catch (e) {
      console.log(e)
      res.json({message: 'erroria', data: e})
      return
    }
    let post = chRes.data.posts.find((post) => {
      return post.no == req.body.post
    })
    if (post) {
      const cleanText = post.com.replace(/<\/?[^>]+(>|$)/g, "");
      let addr = cleanText.match(/0x[a-zA-Z0-9]+/)
      if (addr[0]) {
        try {
          const mintRes = await mint(web3, addr[0], req.body.thread, req.body.post)
          res.json({message: 'success',
            data: mintRes})
        } catch (e) {
          throw e
        }
      }
      
    } else {
      res.json({
        message: 'no post by this number'
      })
      return
    }
  })

  return router
}
