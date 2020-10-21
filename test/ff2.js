const FREN = artifacts.require("FREN");
const DaiMock = artifacts.require("DaiMock");
var UniswapV2Factory = artifacts.require('UniswapV2Factory')
var UniswapV2Router02 = artifacts.require('UniswapV2Router02')
const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'))


contract("FREN", async (accounts) => {
  let mockDaiInstance;
  let frenInstance;


  async function balance(instance, account) {
    return Number(
      web3.utils.fromWei(
        await instance.balanceOf.call(account),
        'ether'
      )
    )
  }

  async function getReserves() {
    
    let response = await frenInstance.getReserves.call()
    return {
      dai: Number(web3.utils.fromWei(response.dai)),
      fren: Number(web3.utils.fromWei(response.fren)),
      timestamp: Number(response.last_timestamp),
    }
  }



  beforeEach("setup", async () => {
    
    mockDaiInstance = await DaiMock.deployed()
    
    frenInstance = await FREN.deployed(
    )

  })

  it("a liquidity pool exists with 100 of each token", async () => {
    let response = await getReserves()
    console.log(response)
    assert.equal(response.dai, 100)
    assert.equal(response.fren, 100)


  })

  it("the fren should be backed by 100 dai", async () => { 
    let response = await balance(mockDaiInstance, frenInstance.address)
    assert.equal(response, 100)
  })
  it("", async () => { 
  })
})

