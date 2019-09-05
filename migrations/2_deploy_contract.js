var FiatFrenzy = artifacts.require('./FiatFrenzy.sol');

module.exports = function(deployer, network, accounts) {
	deployer.deploy(FiatFrenzy, [accounts[1]] )
}
