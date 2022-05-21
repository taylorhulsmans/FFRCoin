pragma solidity ^0.8.0;

import { UTXO, Loan, Account } from '../libraries/LibAppStorage.sol';

import { AppStorage, LibAppStorage, Modifiers } from '../libraries/LibAppStorage.sol';

contract LoanFacet {
  event loanOffer(
    address indexed lendor,
    uint256 indexed index,
    address indexed debtor
  );

  event loanSign(
    address indexed lendor,
    uint256 indexed index,
    address indexed debtor
  );

  event loanRepaid(
    address indexed lendor,
    uint256 indexed index,
    address indexed debtor
  ); 


  function offerLoan(
    address _debtor,
    uint256 _amount,
    uint256 _expiry,
    uint256 _interest
  ) Modifiers.isLoanOfferWithinReserveRatio(
  msg.sender,
  amount,
  expiry
  ) external {
    AppStorage storage s = LibAppStorage.diamondStorage();
    require((_expiry -block.timestamp) > 3600*24, "loans must be at least 24h");
    Loan memory loan = new Loan(_amount, _expiry, false, block.timestamp, 0, _interest);
    s.loans[msg.sender][_debtor].push(loan);
    uint256 index = s.loans[msg.sender][_debtor].length;
    s.loanIndicies[msg.sender][debtor].push(index);



  }

  function signLoan(
    address _lendor,
    uint256 _index
  ) Modifiers.isWithinReserveRatio(
  lendor,
  _loans[lendor][msg.sender][index - 1].principle
  ) external {
    AppStorage storage s = LibAppStorage.diamondStorage();
    Loan memory loan = s.laons[_lendor][msg.sender][_index - 1];

    Account storage lendorAccount = s.accounts[_lendor];
    Account storage debtorAccount = s.accounts[msg.sender];
    debtorAccount.assets += (loan.principle + loan.interest);


    debtorAccount.liabilities += (loan.principle + loan.interest);
    lendorAccount.assets += (loan.principle + loan.interest);
    lendorAccount.liabilities += loan.principle;



  }

  function repayLoan(
    address lendor,
    uint256 index
  ) 
  external {}

}
