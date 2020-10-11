var Helpers = artifacts.require('Helpers');
var FREN = artifacts.require('FREN')
var DaiMock = artifacts.require('DaiMock')
let kovanDai = '0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa'
const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'))
module.exports =  async function(deployer, network, accounts) {
  let initialSupply = web3.utils.toWei('100', 'ether')
  await deployer.deploy(DaiMock, initialSupply);
  daiInstance = await DaiMock.deployed()
  let HelperDeploy = await deployer.deploy(Helpers);
  deployer.link(Helpers, FREN);
  let frenDeploy = await deployer.deploy(FREN, DaiMock.address)
  
}
