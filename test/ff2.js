const FREN = artifacts.require("FREN");
const DaiMock = artifacts.require("DaiMock");
var UniswapV2Factory = artifacts.require('UniswapV2Factory')
var UniswapV2Router02 = artifacts.require('UniswapV2Router02')
var UniswapV2Library = artifacts.require('UniswapV2Library')
const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'))


contract("FREN", async (accounts) => {
  let mockDaiInstance;
  let frenInstance;
  let uniLib;


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
    )
    //uniLib = await UniswapV2Library.deployed()

  })

  it("should have equal fren and dai inside", async () => {
    let fren_dai_0 = await balance(mockDaiInstance, accounts[0])
    let fren_fren_0 = await balance(frenInstance, accounts[0])
    assert.equal(fren_dai_0, fren_fren_0)
    console.log(fren_dai_0, fren_fren_0)

  })

  it("should mint 50 FREN with 50 DAI", async () => {

  })
})

