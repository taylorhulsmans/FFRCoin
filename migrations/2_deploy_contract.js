var FiatFrenzy = artifacts.require('./FiatFrenzy.sol');
var Helpers = artifacts.require('./Helpers.sol');
module.exports = function(deployer, network, accounts) {
	deployer.deploy(Helpers);
	deployer.link(Helpers, FiatFrenzy);
	deployer.deploy(FiatFrenzy, [accounts[0]] )
}
