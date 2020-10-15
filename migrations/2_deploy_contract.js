var Helpers = artifacts.require('Helpers');
var FREN = artifacts.require('FREN')
var DaiMock = artifacts.require('DaiMock')
var AdvancedWETH = artifacts.require('AdvancedWETH')
var UniswapV2Factory = artifacts.require('UniswapV2Factory')
var UniswapV2Router02 = artifacts.require('UniswapV2Router02')
let kovanDai = '0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa'
const RLP = require('rlp')
const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'))



async function allowance(instance, owner, spender) {
  return Number(
    web3.utils.fromWei(
      await instance.allowance.call(owner, spender),
      'ether'
    )
  )
}
async function balance(instance, account) {
  return Number(
    web3.utils.fromWei(
      await instance.balanceOf.call(account),
      'ether'
    )
  )
}


module.exports =  async function(deployer, network, accounts) {
  await deployer.deploy(AdvancedWETH, accounts[0])
  wethInstance = await AdvancedWETH.deployed()

  await deployer.deploy(UniswapV2Factory, accounts[0])
  uniswapFactoryInstance = await UniswapV2Factory.deployed()

  await deployer.deploy(UniswapV2Router02, uniswapFactoryInstance.address, wethInstance.address)
  uniswapRouterInstance = await UniswapV2Router02.deployed()

  let initial = web3.utils.toWei('200', 'ether')
  let halfInitial = web3.utils.toWei('100', 'ether')
  // 200 dai minted to msg.sender
  await deployer.deploy(DaiMock, initial);
  daiInstance = await DaiMock.deployed()
  console.log(await balance(daiInstance, accounts[0]))
  // give half to fren
  await daiInstance.transfer.sendTransaction(FREN.address, halfInitial)
  console.log(await balance(daiInstance, accounts[0]))
  console.log(await balance(daiInstance, FREN.address))

  await daiInstance.approve.sendTransaction(UniswapV2Router02.address, initial)
  let HelperDeploy = await deployer.deploy(Helpers);
  deployer.link(Helpers, FREN);

  await deployer.deploy(FREN, halfInitial, DaiMock.address, uniswapFactoryInstance.address, uniswapRouterInstance.address)
  frenInstance = await FREN.deployed()

  let balance_fren = await balance(frenInstance, accounts[0])
  console.log(balance_fren)

  await frenInstance.approve.sendTransaction(UniswapV2Router02.address, initial)
  // createLiquidity
  //
  console.log(await allowance(daiInstance, accounts[0], UniswapV2Router02.address))
  console.log(await allowance(frenInstance, accounts[0], UniswapV2Router02.address))
  await uniswapRouterInstance.addLiquidity(
    DaiMock.address,
    FREN.address,
    halfInitial,
    halfInitial,
    0,
    0,
    accounts[0],
    Math.floor(Date.now() / 1000) + 3600
  )
  
  
  
}
