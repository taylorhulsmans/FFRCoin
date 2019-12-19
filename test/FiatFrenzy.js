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
		assert.equal(100, web3.utils.fromWei(totalSupply, 'ether'))
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
    balance_1 = web3.utils.fromWei(balance_1, 'ether')
    let proof = await instance.proofOfMeme.sendTransaction(accounts[1], 123456666, {from:accounts[0]})
    let balance_2 = await instance.balanceOf.call(accounts[1])
    balance_2 = web3.utils.fromWei(balance_2, 'ether')
    assert.equal(balance_2 - balance_1, 6666)
  })
	it("should give correct time adjusted RR at a year equal to reserve ratio", async () => {
		let tarr = await instance.timeAdjustedRR.call(
			Math.floor((new Date().getTime() / 1000)) + (60*60*24*365
			))
		let rr= await instance.reserveRequirement.call()
		assert.equal(Number(tarr), Number(rr))
	})

	it("should give correct time adjusted RR at a 1/2 year is half", async () => {
		let tarr = await instance.timeAdjustedRR.call(
			Math.floor((new Date().getTime() / 1000)) + (60*60*24*(365/2
			)))
		let rr= await instance.reserveRequirement.call()
		assert.equal(Number(tarr), 308170372472550200)
	})

	it("lending should feel restricted for short loans", async () => {
		let tarr = await instance.timeAdjustedRR.call(
			Math.floor((new Date().getTime() / 1000)) + (3600*24))
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
    balanceOf = web3.utils.fromWei(balanceOf, 'ether')
    let deci = 1.1234567
    let wei = web3.utils.toWei(deci.toString(), 'ether')
    let mint = await instance.operatorMint.sendTransaction(accounts[0], web3.utils.toBN(wei), {from: accounts[0]})
    let balanceOf2 = await instance.balanceOf.call(accounts[0]);
    balanceOf2 = web3.utils.fromWei(balanceOf2, 'ether')
    assert.equal(Number(balanceOf) + Number( deci ), balanceOf2 )
    try {
      let mintHack = await instance.operatorMint.sendTransaction(accounts[0], 100)
    } catch (e) {
      assert.equal(e, 'Error: Returned error: VM Exception while processing transaction: revert executive function only -- Reason given: executive function only.')
    }
  });

  it("can send tokens", async () => {
    let sendAmount = web3.utils.toWei('50', 'ether')
    let send = await instance.send.sendTransaction(accounts[2], sendAmount, '0xff');
    let balance0 = await instance.balanceOf.call(accounts[0])
    balance0 = web3.utils.fromWei(balance0, 'ether')
    let balance2 = await instance.balanceOf.call(accounts[2])
    balance2 = web3.utils.fromWei(balance2, 'ether')
    assert.equal(Number(balance0), 51.1234567)
    assert.equal(balance2, 50)
  });

	it("can offer a loan", async () => {
    const now = new Date().getTime() / 1000
    const expiry = Math.floor(now*3600*24*14) // 14 days ahead
    const amount = web3.utils.toWei('5', 'ether')
    const interest = web3.utils.toWei('0.25', 'ether')
    let offerLoan = await instance.offerLoan.sendTransaction(accounts[3], amount, expiry, interest, {from: accounts[2]})
    let index = await instance.getLoanIndex.call(accounts[2], accounts[3])
    assert.equal(index, 1);
  })

  it("can sign a loan", async () => {
    let signLoan = await instance.signLoan.sendTransaction(accounts[2], 1, {from: accounts[3]});
    let balanceOf3 = await instance.balanceOf.call(accounts[3])
    balanceOf3 = web3.utils.fromWei(balanceOf3, 'ether')
    assert.equal(balanceOf3, 5)
    let liabilitiesOf3 = await instance.liabilitiesOf.call(accounts[3])
    liabilitiesOf3 = web3.utils.fromWei(liabilitiesOf3, 'ether')
    assert.equal(liabilitiesOf3, 5.25)
  })

	it("can't loan past the reserveratio", async () => {
		let balance = await instance.balanceOf(accounts[2])
		let liabilities = await instance.liabilitiesOf(accounts[2])
		let assets = await instance.assetsOf(accounts[2])
		balance = web3.utils.fromWei(balance, 'ether')
    liabilities = web3.utils.fromWei(liabilities, 'ether')
    assets = web3.utils.fromWei(assets, 'ether')
    // liabilites / money coming in (assets) + balance <= 0.618
		let currentRatio = (liabilities / (balance));
		
		let reserveRequirement = 0.618033989
		
    try {
      let amount = web3.utils.toWei('20', 'ether')
      let interest = web3.utils.toWei('5', 'ether')

      const now = new Date().getTime() / 1000
      const expiry = Math.floor(now*3600*24*14) // 14 days ahead
			let offerLoan = await instance.offerLoan.sendTransaction(accounts[3], amount, expiry, interest, {from: accounts[2]});
		} catch (e) {
			assert.fail(e)
		}
		let signLoan = await instance.signLoan.sendTransaction(accounts[2], 2, {from: accounts[3]});
	  let balance2 = await instance.balanceOf(accounts[2])
		let liabilities2 = await instance.liabilitiesOf(accounts[2])
		let assets2 = await instance.assetsOf(accounts[2])
		
		balance2 = web3.utils.fromWei(balance2, 'ether')
		liabilities2 = web3.utils.fromWei(liabilities2, 'ether')
		assets2 = web3.utils.fromWei(assets2, 'ether')
		
		currentRatio = (liabilities2 / balance2);
			
	});

	it("can repay a loan", async () => {
    let balance3 = await instance.balanceOf(accounts[3])

    balance3 = web3.utils.fromWei(balance3, 'ether')
    let liabilities3 = await instance.liabilitiesOf(accounts[3])
    liabilities3 = web3.utils.fromWei(liabilities3, 'ether')
    let assets3 = await instance.assetsOf(accounts[3])
    assets3 = web3.utils.fromWei(assets3, 'ether')
		
		let loan = await instance.getLoan(accounts[2], accounts[3], 1)
		
    let balance2 = await instance.balanceOf(accounts[2])
    balance2 = web3.utils.fromWei(balance2, 'ether')
    let liabilities2 = await instance.liabilitiesOf(accounts[2])
    liabilities2 = web3.utils.fromWei(liabilities2, 'ether')
    let assets2 = await instance.assetsOf(accounts[2])
    assets2 = web3.utils.fromWei(assets2, 'ether')
		let repayLoan = await instance.repayLoan(accounts[2], 1, {from: accounts[3]})
    balance3 = await instance.balanceOf(accounts[3])

    balance3 = web3.utils.fromWei(balance3, 'ether')
		liabilities3 = await instance.liabilitiesOf(accounts[3])
    
    liabilities3 = web3.utils.fromWei(liabilities3, 'ether')
    assets3 = await instance.assetsOf(accounts[3])

    assets3 = web3.utils.fromWei(assets3, 'ether')
		loan = await instance.getLoan(accounts[2], accounts[3], 1)
		balance2 = await instance.balanceOf(accounts[2])
		liabilities2 = await instance.liabilitiesOf(accounts[2])
		assets2 = await instance.assetsOf(accounts[2])

		
		assert.equal(balance3, 19.75)
		assert.equal(liabilities3, 25.25)
		assert.equal(assets3, 0)
	})

  it('can transfer', async () => {

    let wei = web3.utils.toWei('10', 'ether')
    let transfer = await instance.transfer(accounts[1], wei)
  })
  it('can calculate outstanding interest', async () => {
    // Outstanding Interest
    // total tokens
    // and the floating reserve ratio
    // given that outstanding interest must come from new loans received
    // it is worth considering the pegging the reserve requirement to incentivize new loans
    // but what is the function that relates outstanding interest to the reserve requirement?
    // this is the question
    
    let totalSupplyInit = await instance.totalSupply()
    let outstandingInterest = await instance.outstandingInterest()


  })

})
