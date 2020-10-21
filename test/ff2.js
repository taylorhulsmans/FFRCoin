const FREN = artifacts.require("FREN");
const DaiMock = artifacts.require("DaiMock");
var UniswapV2Factory = artifacts.require('UniswapV2Factory')
var UniswapV2Router02 = artifacts.require('UniswapV2Router02')
const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'))


contract("FREN", async (accounts) => {
  let mockDaiInstance;
  let frenInstance;
  let routerInstance;


  let duoDai = web3.utils.toWei('1', 'ether')

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
    
    frenInstance = await FREN.deployed()

    routerInstance = await UniswapV2Router02.deployed()

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

  it("dai is swapped for fren", async () => {
    let user1_dai_0 = await balance(mockDaiInstance, accounts[0])
    let user1_fren_0 = await balance(frenInstance, accounts[0])
    assert.equal(user1_dai_0, 100)
    assert.equal(user1_fren_0, 0)
    let duoDai = web3.utils.toWei('2', 'ether')
    await mockDaiInstance.approve.sendTransaction(routerInstance.address, duoDai)
    await frenInstance.approve.sendTransaction(routerInstance.address, duoDai)
    let path = [mockDaiInstance.address, frenInstance.address]
    let swap = await routerInstance.swapTokensForExactTokens.sendTransaction(
      web3.utils.toWei('1', 'ether'),
      web3.utils.toWei('2', 'ether'),
      path,
      accounts[0],
      Math.floor(Date.now() / 1000) + 3600
    )
    let user1_dai_1 = await balance(mockDaiInstance, accounts[0])
    let user1_fren_1 = await balance(frenInstance, accounts[0])
    assert.equal(user1_fren_1, 1)
    assert.isBelow(user1_dai_1, 99)
    console.log(await getReserves())
  })
})

