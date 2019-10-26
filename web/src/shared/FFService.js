import axios from 'axios';

export async function getContract() {
  let contractData = null;
  try {
    contractData = await axios.get('api/contract');
  } catch (e) {
    return e;
  }
  const { address } = contractData.data;
  const { abi } = contractData.data.FiatFrenzy;
  return new window.web3.eth.Contract(abi, address);
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
    const balance = await contract.methods.balanceOf(address).call();
    const liabilities = await contract.methods.liabilitiesOf(address).call();
    const assets = await contract.methods.assetsOf(address).call();
    return {
      balance,
      liabilities,
      assets,
    };
  } catch (e) {
    return e;
  }
}

export async function offerLoan(sender, address, amount, posixDate) {
  const contract = await getContract();
  try {
    return await contract.methods.offerLoan(address, amount).send({ from: sender });
  } catch (e) {
    return e;
  }
}

export async function getLoans() {
  const address = await addresses()
  const contract = await getContract();
  const loanOfferEvents = await contract.getPastEvents('loanOffer', {
    filter: {
      _lendor: address[0],
    },
    fromBlock: '0',
    toBlock: 'latest',
  }, (err, result) => {
    return result
  })
  const loans = loanOfferEvents.map(async (event) => {
    const debtor = event.returnValues._debtor;
    const index = event.returnValues._index;
    const result = await contract.methods.getLoan(address[0], debtor, index).call()
    return {
      debtor,
      amount: result[0],
      expiry: result[1],
      isApproved: result[2],
    }
  })
  return Promise.all(loans).then((completed) => {
    
    return completed;
  });
}


