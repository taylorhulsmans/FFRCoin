var Helpers = artifacts.require('Helpers');
var DecimalMath = artifacts.require('DecimalMath')
var FREN = artifacts.require('FREN')
var DaiMock = artifacts.require('DaiMock')
var AdvancedWETH = artifacts.require('AdvancedWETH')
var UniswapV2Factory = artifacts.require('UniswapV2Factory')
var UniswapV2Router02 = artifacts.require('UniswapV2Router02')
var UniswapV2Library = artifacts.require('UniswapV2Library')
var ExampleSlidingWindowOracle = artifacts.require('ExampleSlidingWindowOracle')
let kovanDai = '0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa'
const RLP = require('rlp')
const keccak = require('keccak')
const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))



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

function frenAddr(sender, nonce) {
  var input_arr = [ sender, nonce ];
  var rlp_encoded = RLP.encode(input_arr)

  var contract_address_long = keccak('keccak256').update(rlp_encoded).digest('hex');
  return contract_address_long.substring(24); //Trim the first 24 characters.
  
}



module.exports =  async function(deployer, network, accounts) {
  /*
   * Helpers
   */
  let DecimalMathDeploy = await deployer.deploy(DecimalMath);
  deployer.link(DecimalMath, FREN);
  let HelperDeploy = await deployer.deploy(Helpers);
  deployer.link(Helpers, FREN);


  /*
   * Deps for fake
   */
  await deployer.deploy(AdvancedWETH, accounts[0])
  wethInstance = await AdvancedWETH.deployed()

  /*
   * Uniswap
   */
  await deployer.deploy(UniswapV2Library)
  await deployer.deploy(UniswapV2Factory, accounts[0])
  uniswapFactoryInstance = await UniswapV2Factory.deployed()

  await deployer.deploy(UniswapV2Router02, uniswapFactoryInstance.address, wethInstance.address)
  uniswapRouterInstance = await UniswapV2Router02.deployed()

  //https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/examples/ExampleSlidingWindowOracle.sol#L28
  await deployer.deploy(ExampleSlidingWindowOracle, uniswapFactoryInstance.address, 24, 24)
  exampleSlidingWindowOracleInstance = await ExampleSlidingWindowOracle.deployed()

  /*
   * 100 dai to the swap
   * 100 dai to back the fren 1:1
   * 100 dai for user 1 to test the optimistic case
   */
  let initialDai = web3.utils.toWei('300', 'ether')
  let centiDai = web3.utils.toWei('100', 'ether')
  // 200 dai minted to msg.sender
  await deployer.deploy(DaiMock, initialDai);
  daiInstance = await DaiMock.deployed()

  //
  //
  await daiInstance.approve.sendTransaction(UniswapV2Router02.address, centiDai)


  let nonce = await web3.eth.getTransactionCount(accounts[0], 'pending')
  nonce = nonce + 1
  let frenFutureAddress = frenAddr(
    accounts[0],
    nonce
  )
  console.log('future', frenFutureAddress)
  await daiInstance.transfer.sendTransaction(frenFutureAddress, centiDai)

  await deployer.deploy(FREN, centiDai, daiInstance.address, uniswapFactoryInstance.address, uniswapRouterInstance.address, exampleSlidingWindowOracleInstance.address )
  frenInstance = await FREN.deployed()

  //let obs = await frenInstance.pairObservations.call()
  //console.log(obs)
  let balance_fren = await balance(frenInstance, accounts[0])
  let balance_dai = await balance(daiInstance, accounts[0])
  await frenInstance.approve.sendTransaction(UniswapV2Router02.address, centiDai)
  // createLiquidity
  //
  console.log(balance_fren)
  console.log(balance_dai)
  console.log(await allowance(frenInstance, accounts[0], uniswapRouterInstance.address))
  console.log(await allowance(daiInstance, accounts[0], uniswapRouterInstance.address))
  let response = await uniswapRouterInstance.addLiquidity.sendTransaction(
    daiInstance.address,
    frenInstance.address,
    centiDai,
    centiDai,
    0,
    0,
    accounts[0],
    Math.floor(Date.now() / 1000) + 3600
  )



  
  
  
  
}
