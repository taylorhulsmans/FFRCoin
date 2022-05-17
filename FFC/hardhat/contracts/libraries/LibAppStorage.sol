pragma solidity ^0.8.0;

import {LibDiamond} from './LibDiamond.sol';

struct Organization {
}

struct Account {
  uint256 credibilityPoints;
  //uint256 newAccountOutflowRestrictor;
  uint256 assets;
  uint256 liabilities;
  uint256 outstandingInterest;   

}

struct Loan {
  uint256 principle;
  uint256 expiry;
  bool isApproved;
  uint256 signedAt;
  uint256 createdAt;
  uint256 interest;
}

struct UTXO {
  address owner;
  uint256 value;
  bytes32 createdBy;
  bytes32 id;
  // Modified UTXO
  address origin; // UTXO's created by lending have this address
  uint256 gasCumulative; // Gas cumulative from Origin, used for repayment penalty
}

struct AppStorage {
  uint256 helloInt;
  // global loan state
  uint256 reserveLimit;
  uint256 totalCredibilityPoints;
  mapping (address => Account) accounts;
  mapping (address => mapping (address => Loan[])) loans;
  mapping (address => mapping (address => uint256[])) loanIndicies;
  // coin state
  mapping (bytes32 => UTXO) utxos;
  uint256 totalSupply;



}

library LibAppStorage {
  function diamondStorage() internal pure returns (AppStorage storage ds) {
    assembly {
      ds.slot := 0
    }
  }

  function abs(int256 x) internal pure returns (uint256) {
    return uint256(x >= 0 ? x : -x);
  }
}

contract Modifiers {
  AppStorage internal s;

  modifier onlyOwner() {
    LibDiamond.enforceIsContractOwner();
    _;
  }

}
