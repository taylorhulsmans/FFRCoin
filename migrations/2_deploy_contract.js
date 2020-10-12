var Helpers = artifacts.require('Helpers');
var FREN = artifacts.require('FREN')
var DaiMock = artifacts.require('DaiMock')
var AdvancedWETH = artifacts.require('AdvancedWETH')
var UniswapV2Factory = artifacts.require('UniswapV2Factory')
var UniswapV2Router02 = artifacts.require('UniswapV2Router02')
let kovanDai = '0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa'
const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'))
module.exports =  async function(deployer, network, accounts) {
  await deployer.deploy(AdvancedWETH, accounts[0])
  wethInstance = await AdvancedWETH.deployed()
  await deployer.deploy(UniswapV2Factory, accounts[0])
  uniswapFactoryInstance = await UniswapV2Factory.deployed()

  await deployer.deploy(UniswapV2Router02, uniswapFactoryInstance.address, wethInstance.address)
  uniswapRouterInstance = await UniswapV2Router02.deployed()
  let initialSupply = web3.utils.toWei('200', 'ether')
  await deployer.deploy(DaiMock, initialSupply);
  daiInstance = await DaiMock.deployed()
  let HelperDeploy = await deployer.deploy(Helpers);
  deployer.link(Helpers, FREN);
  await deployer.deploy(FREN, DaiMock.address, uniswapFactoryInstance.address, uniswapRouterInstance.address)
  frenInstance = await FREN.deployed()
  
  
}
