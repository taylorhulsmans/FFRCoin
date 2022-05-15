pragma solidity ^0.7.1;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract DaiMock is ERC20 {
  constructor(uint256 initialSupply) ERC20('Silver', 'SLV') {
    _mint(msg.sender, initialSupply);
  }
}
