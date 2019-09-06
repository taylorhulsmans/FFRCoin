const FiatFrenzy = artifacts.require("FiatFrenzy");

contract("FiatFrenzy", async (accounts) => {
	let instance;

	beforeEach("setup contract for each test", async () => {
		instance = await FiatFrenzy.deployed(accounts[1]);
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
		// can message sender operator the oracle address?
		let opOne = await instance.isOperatorFor.call(accounts[0], accounts[1])
		assert.equal(false, opOne)
		// can the oracle address operate for message.sender?
		let opTwo = await instance.isOperatorFor.call(accounts[1], accounts[0])
		assert.equal(true, opTwo)
		// can oracle operate for itself
		let opThree = await instance.isOperatorFor.call(accounts[1], accounts[1])
		assert.equal(true, opThree)
	})

	it("set a third party operator as an operator of msg.sender", async () => {
		// accounts[0] authorizes accounts[2]
		let authorize = await instance.authorizeOperator.sendTransaction(accounts[2])
		// This means accounts[2] is Operator For accounts[0]
		let zeroOpTwo = await instance.isOperatorFor.call(accounts[2], accounts[0])	
	})

	it("the default operator can break these connections", async () => {
		let zeroAuthDef = await instance.isOperatorFor.call(accounts[1], accounts[0])
		assert.equal(true, zeroAuthDef)
		// when _defaultOperator[_operator] is true
		let defaultOperator = await instance.defaultOperators.call()
		// account[0] authorize default operator
		let authorize = await instance.authorizeOperator.sendTransaction(defaultOperator[0])

		zeroAuthDef = await instance.isOperatorFor.call(accounts[1], accounts[0])
		assert.equal(true, zeroAuthDef)
	})

	it("a third party can revoke", async () => {
		
		let zeroOpTwo = await instance.isOperatorFor.call(accounts[2], accounts[0])	
		assert.equal(true, zeroOpTwo)

		let deAuthorize = await instance.revokeOperator.sendTransaction(accounts[2])

		zeroOpTwo = await instance.isOperatorFor.call(accounts[2], accounts[0])	
		assert.equal(false, zeroOpTwo)
	})





})
