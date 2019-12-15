const FiatFrenzy = artifacts.require("FiatFrenzy");
const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'))
// Account helper

contract("FiatFrenzy", async (accounts) => {
	let instance;
	let loanOffers;

	beforeEach("setup contract for each test", async () => {
    instance = await FiatFrenzy.deployed(accounts[0]);
    loanOffers = await instance.getPastEvents('loanOffer', {
      fromBlock: 0,
      toBlock: 'latest'
    }, (err, result) => {
      if (!err) {
        return result
      } else {
        console.log(error)
      }
    })
	})

	it("should return the name", async () => {
		let name = await instance.name.call();
		assert.equal("Fiat Frenzy", name)
	})

	it("should return symbol", async () => {
		let symbol = await instance.symbol.call();
		assert.equal("FREN", symbol)
	})

	it("should return total Supply", async () => {
		let totalSupply = await instance.totalSupply.call();
		assert.equal(totalSupply, 0)
	})

	it("should return balance of", async () => {
		let balanceOf = await instance.balanceOf.call(accounts[0]);
		assert.equal(100*10**18, Number(balanceOf))
	})

	it("should return granularity", async () => {
		let granularity = await instance.granularity.call();
		assert.equal(1, granularity)
	})

	it("should return true for account[0] default operator", async () => {
		let defaultOps = await instance.defaultOperators.call();
		assert.equal(accounts[0], defaultOps)
	})
  it("should proof of meme", async () => {
    let balance_1 = await instance.balanceOf.call(accounts[1])
    console.log('balancea', Number(balance_1))
    let proof = await instance.proofOfMeme.sendTransaction(accounts[1], 123456666, {from:accounts[0]})
    let balance_2 = await instance.balanceOf.call(accounts[1])
    console.log('balance2', Number(balance_2))
    assert.equal(Number(balance_2) - Number(balance_1), 6666)
  })
	it("should give correct time adjusted RR at a year equal to reserve ratio", async () => {
		let tarr = await instance.timeAdjustedRR.call(
			Math.floor((new Date().getTime() / 1000)) + (60*60*24*365
			))
		let rr= await instance.reserveRequirement.call()
		console.log('1 tarr', Number(tarr), 'rr', Number(rr))
		assert.equal(Number(tarr), Number(rr))
	})

	it("should give correct time adjusted RR at a 1/2 year is half", async () => {
		let tarr = await instance.timeAdjustedRR.call(
			Math.floor((new Date().getTime() / 1000)) + (60*60*24*(365/2
			)))
		let rr= await instance.reserveRequirement.call()
		console.log('1 tarr', Number(tarr), 'rr', Number(rr))
		assert.equal(Number(tarr), 308170372472550200)
	})

	it("lending should feel restricted for short loans", async () => {
		let tarr = await instance.timeAdjustedRR.call(
			Math.floor((new Date().getTime() / 1000)) + (3600*24))
		console.log('2 tarr', Number(tarr), 'rr')
    assert.equal(Number(tarr), 1693243804794232)
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

  it("accounts[0] is the only one who can mint tokens", async () => {
    let balanceOf = await instance.balanceOf.call(accounts[0]);
    console.log(Number(balanceOf))
    let deci = 1.1234567
    let wei = web3.utils.toWei(deci.toString(), 'ether')
    let mint = await instance.operatorMint.sendTransaction(accounts[0], web3.utils.toBN(wei), {from: accounts[0]})
    let balanceOf2 = await instance.balanceOf.call(accounts[0]);
    assert.equal(Number(balanceOf2), 1)
    try {
      let mintHack = await instance.operatorMint.sendTransaction(accounts[0], 100)
    } catch (e) {
      assert.equal(e, 'Error: Returned error: VM Exception while processing transaction: revert executive function only -- Reason given: executive function only.')
    }
  });

  it("can send tokens", async () => {
    let send = await instance.send.sendTransaction(accounts[2], 50, '0xff');
    let balance0 = await instance.balanceOf.call(accounts[0])
    let balance2 = await instance.balanceOf.call(accounts[2])
    assert.equal(Number(balance0), 150)
    assert.equal(balance2, 50)
  });

	it("can offer a loan", async () => {
		const now = new Date().getTime() / 1000
    let offerLoan = await instance.offerLoan.sendTransaction(accounts[3], 10, Math.floor(now*3601*24), {from: accounts[2]})
    let index = await instance.getLoanIndex.call(accounts[2], accounts[3])
    assert.equal(index, 1);
  })

	it("can offer a loan that isn't whole number", async () => {
		const now = new Date().getTime() / 1000
    let offerLoan = await instance.offerLoan.sendTransaction(accounts[3], String(10.1), Math.floor(now*3601*24), {from: accounts[2]})
    let index = await instance.getLoanIndex.call(accounts[2], accounts[3])
    assert.equal(index, 2);
  })

  it("can sign a loan", async () => {
    let signLoan = await instance.signLoan.sendTransaction(accounts[2], 1, {from: accounts[3]});
    let balanceOf3 = await instance.balanceOf.call(accounts[3])
    assert.equal(balanceOf3, 10)
    let liabilitiesOf3 = await instance.liabilitiesOf.call(accounts[3])
    assert.equal(liabilitiesOf3, 10)
  })

	it("can't loan past the reserveratio", async () => {
		let balance = await instance.balanceOf(accounts[2])
		let liabilities = await instance.liabilitiesOf(accounts[2])
		let assets = await instance.assetsOf(accounts[2])
		balance = balance.toNumber()
		liabilities =liabilities.toNumber()
		assets = assets.toNumber()
		// liabilites / money coming in (assets) + balance <= 0.618
		let currentRatio = (liabilities / (balance));
		
		let reserveRequirement = 0.618033989
		console.log(balance, liabilities, assets)
		
		try {
			let offerLoan = await instance.offerLoan.sendTransaction(accounts[3], 20, 3600*24, {from: accounts[2]});
		} catch (e) {
			assert.fail(e)
		}
		let signLoan = await instance.signLoan.sendTransaction(accounts[2], 2, {from: accounts[3]});
	  let balance2 = await instance.balanceOf(accounts[2])
		let liabilities2 = await instance.liabilitiesOf(accounts[2])
		let assets2 = await instance.assetsOf(accounts[2])
		
		balance2 = balance2.toNumber()
		liabilities2 = liabilities2.toNumber()
		assets2 = assets2.toNumber()
		
		currentRatio = (liabilities2 / balance2);
			
	});

	it("can repay a loan", async () => {
		let balance3 = await instance.balanceOf(accounts[3])
		let liabilities3 = await instance.liabilitiesOf(accounts[3])
		let assets3 = await instance.assetsOf(accounts[3])
		
		let loan = await instance.getLoan(accounts[2], accounts[3], 1)
		
		let balance2 = await instance.balanceOf(accounts[2])
		let liabilities2 = await instance.liabilitiesOf(accounts[2])
		let assets2 = await instance.assetsOf(accounts[2])
		console.log('loan', loan[0].toNumber())	
		console.log('debtor', balance3.toNumber(), liabilities3.toNumber(), assets3.toNumber())	
		
		console.log('lendor', balance2.toNumber(), liabilities2.toNumber(), assets2.toNumber())	
		let repayLoan = await instance.repayLoan(accounts[2], 1, {from: accounts[3]})
		balance3 = await instance.balanceOf(accounts[3])
		liabilities3 = await instance.liabilitiesOf(accounts[3])
		assets3 = await instance.assetsOf(accounts[3])

		loan = await instance.getLoan(accounts[2], accounts[3], 1)
		console.log('loan', loan[0].toNumber())	
		console.log( 'debtor', balance3.toNumber(), liabilities3.toNumber(), assets3.toNumber())

		console.log('lendor', balance2.toNumber(), liabilities2.toNumber(), assets2.toNumber())	
		balance2 = await instance.balanceOf(accounts[2])
		liabilities2 = await instance.liabilitiesOf(accounts[2])
		assets2 = await instance.assetsOf(accounts[2])

		
		assert.equal(balance3.toNumber(), 30 - 10)
		assert.equal(liabilities3.toNumber(), 30 - 10)
		assert.equal(assets3.toNumber(), 0)
	})

  it('can transfer', async () => {

    let wei = web3.utils.toWei('10', 'ether')
    console.log(instance)
    let transfer = await instance.transfer(accounts[1], wei)


  })


})
