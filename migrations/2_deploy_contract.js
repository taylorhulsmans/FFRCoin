var FiatFrenzy = artifacts.require('FiatFrenzy');
var Helpers = artifacts.require('Helpers');
module.exports = function(deployer, network, accounts) {
  deployer.deploy(Helpers);
  deployer.link(Helpers, FiatFrenzy);
  deployer.deploy(FiatFrenzy, [accounts[0]])
}
