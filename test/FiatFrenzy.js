const FiatFrenzy = artifacts.require("FiatFrenzy");

contract("FiatFrenzy", async (accounts) => {
	let instance;

	beforeEach("setup contract for each test", async () => {
		instance = await FiatFrenzy.deployed();
	})

	it("should return the name", async () => {
		let name = await instance.name.call();
		assert.equal("Fiat Frenzy", name)
	})

	it("should return symbol", async () => {
		let symbol = await instance.symbol.call();
		assert.equal("FRNZY", symbol)
	})

	it("should return total Supply", async () => {
		let totalSupply = await instance.totalSupply.call();
		assert.equal(totalSupply, 0)
	})

	it("should return balance of", async () => {
		let balanceOf = await instance.balanceOf.call(accounts[0]);
		assert.equal(0, balanceOf)
	})

	it("should return granularity", async () => {
		let granularity = await instance.granularity.call();
		assert.equal(1, granularity)
	})

	it("should return default operator", async () => {
		let defaultOps = await instance.defaultOperators.call();
		assert.equal(accounts[1], defaultOps)
	})

	it("should return if operator or not", async () => {
		let opOne = await instance.isOperatorFor.call(accounts[0], accounts[1])
		assert.equal(false, opOne)
		let opTwo = await instance.isOperatorFor.call(accounts[1], accounts[0])
		assert.equal(false, opTwo)
		let opThree = await instance.isOperatorFor.call(accounts[1], accounts[1])
		assert.equal(true, opThree)
	})




})
