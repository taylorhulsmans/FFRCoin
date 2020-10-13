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


  beforeEach("setup", async () => {
    
    mockDaiInstance = await DaiMock.deployed()
    frenInstance = await FREN.deployed(
      DaiMock.address,
      UniswapV2Factory.address,
      UniswapV2Router02.address
    )

  })

  it("should have 100 dai inside", async () => {
    let fren_dai_0 = await balance(mockDaiInstance, accounts[0])
    assert.equal(fren_dai_0, 200)
    let transfer = await mockDaiInstance.transfer.sendTransaction(
      FREN.address,
      web3.utils.toWei('100', 'ether')
    )
    let fren_dai_1 = await balance(mockDaiInstance, accounts[0])
    assert.equal(fren_dai_1, 100)
  })
})

