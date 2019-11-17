import axios from 'axios';
import * as contractData from '../assets/FiatFrenzy.json';
export async function getContract() {
  let addr = null;
  if (process.env.NODE_ENV === 'development') {
    addr = '0xD426993bB1984762915B4EC481b66b41d99e7e01'
  } else {
    addr = '0xA9d0c0ad6749684dC25C2F48AC6049e77a2A2F9A'
  }
  const {abi} = contractData.default;
  return new window.web3.eth.Contract(abi, addr);
}


export async function addresses() {
  try {
    return await window.ethereum.enable();
  } catch (e) {
    return e;
  }
}

export async function getAccount(address) {
  const contract = await getContract();
  try {
    const balance = Number(await contract.methods.balanceOf(address).call());
    const liabilities = Number(await contract.methods.liabilitiesOf(address).call());
    const assets = Number(await contract.methods.assetsOf(address).call());
    return {
      balance,
      liabilities,
      assets,
    };
  } catch (e) {
    return e;
  }
}

export async function proveMemeAndMint(thread, post) {
  let res = await axios.post('/api/mint', {
    thread,
    post
  })
  return res
}

export async function getTimeAdjustedRR(expiry) {
  const contract = await getContract();
  try {
    const adjustedRR = await contract.methods.timeAdjustedRR(expiry).call();
    return adjustedRR;
  } catch (e) {
    console.log(e)
    return e;
  }
}

export async function offerLoan(sender, address, amount, posixDate) {
  const contract = await getContract();
  try {
    return await contract.methods.offerLoan(address, Number(amount), posixDate).send({ from: sender });
  } catch (e) {
    return e;
  }
}

export async function getLoans() {
  const address = await addresses();
  const contract = await getContract();
  const loanOfferEvents = await contract.getPastEvents('loanOffer', {
    filter: {
      _lendor: address[0],
    },
    fromBlock: '0',
    toBlock: 'latest',
  }, (err, result) => {
    if (err) {
      return err
    }
    return result
  })
  const loans = loanOfferEvents.map(async (event) => {
    const debtor = event.returnValues._debtor;
    const index = event.returnValues._index;
    const result = await contract.methods.getLoan(address[0], debtor, index).call()
    return {
      debtor,
      amount: result[0],
      expiry: new Date(result[1]*1000).toISOString().substr(0,10),
      isApproved: result[2],
    }
  })
  return Promise.all(loans).then((completed) => {
    
    return completed;
  });
}

export async function getDebts() {
  const address = await addresses()
  const contract = await getContract();
  const loanOfferEvents = await contract.getPastEvents('loanOffer', {
    filter: {
      _debtor: address[0],
    },
    fromBlock: '0',
    toBlock: 'latest',
  }, (err, result) => {
    return result
  })
  const signLoanEvents = await contract.getPastEvents('loanSign', {
    filter: {
      _debtor: address[0]
    },
    fromBlock: '0',
    toBlock: 'latest',
  }, (err, result) => {
    if (err) {
      return err
    } else {
      return result;
    }
  })
  const loans = loanOfferEvents.map(async (event) => {
    const debtor = event.returnValues._debtor;
    const lendor = event.returnValues._lendor;
    const index = event.returnValues._index;
    const result = await contract.methods.getLoan(lendor, address[0], index).call()
    const isApproved = signLoanEvents.some((signedLoan) => {
      return signedLoan.returnValues._index == index &&
        signedLoan.returnValues._debtor == debtor 
    })
    return {
      lendor,
      index,
      amount: result[0],
      expiry: new Date(result[1]*1000).toISOString().substr(0,10),
      isApproved,
    }
  })

  return Promise.all(loans).then((completed) => {
    
    return completed;
  });
}

export async function signLoan(lendor, index) {
  const address = await addresses()
  const contract = await getContract();
  try {
    const event = await contract.methods.signLoan(lendor, index).send({ from: address[0] })
    return event
  } catch (e) {
    return e
  }
}

export async function repayLoan(lendor, index) {
  const address = await addresses();
  const contract = await getContract();
  try {
    const event = await contract.methods.repayLoan(lendor, index).send({ from: address[0] });
    return event;
  } catch (e) {
    return e;
  }
}

export async function calculateAvailable(
  expiry
) {
  const address = await addresses();
  const account = await getAccount(address[0]);
  const timeAdjustedRR = await getTimeAdjustedRR(expiry);
  console.log('hmm')
  const not = 10 ** 9;
  const decimalRatio = (timeAdjustedRR / not);
  const val = ((decimalRatio) * account.balance) - account.liabilities
  return Math.floor(val)

}
