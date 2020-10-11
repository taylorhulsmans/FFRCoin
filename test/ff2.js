const FREN = artifacts.require("FREN");
const DaiMock = artifacts.require("DaiMock");
const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'))


contract("FREN", async (accounts) => {
  let mockDaiInstance;
  let frenInstance;
  beforeEach("setup", async () => {
    
    let initialSupply = web3.utils.toWei('100', 'ether')
    mockDaiInstance = await DaiMock.deployed(initialSupply)
    frenInstance = await FREN.deployed(initialSupply, DaiMock.address);
  })

  it("should have 100 dai inside", async () => {
    console.log(mockDaiInstance)
    let daiBalance = web3.utils.fromWei(await mockDaiInstance.methods['balanceOf(address)'](accounts[0]), 'ether')
    console.log(Number(daiBalance))
    let transfer = await mockDaiInstance.methods['transfer(address,uint256)'](FREN.address, web3.utils.toWei('100', 'ether'))
    
    let frenBalance = web3.utils.fromWei(await frenInstance.methods['balanceOf(address)'](accounts[0]), 'ether')
    console.log(Number(frenBalance))
  })
})
