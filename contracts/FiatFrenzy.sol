pragma solidity 0.5.8;
import { IERC777Token } from './IERC777.sol';
contract FiatFrenzy is IERC777Token {
  // Coin Meta
  string internal _name;
  string internal _symbol;
  uint256 internal _totalSupply;
  uint256 internal _granularity;
  
  // Operator Stuff
  event AuthorizedOperator(
    address indexed operator,
    address indexed holder
  );

  event RevokedOperator(address indexed operator, address indexed holder);
  
  address[] internal _defaultOperators;
  mapping(address => bool) internal _isDefaultOperator;
  mapping(address => mapping(address => bool)) internal _revokedDefaultOperator;
  mapping(address => mapping(address => bool)) internal _authorizedOperators;
  
  // Frenzy
  struct Account {
    uint256 _balance;
    uint256 _assets;
    uint256 _liabilities;
  }
  mapping (address => Account) _accounts;
  
  modifier notSelf(address sender, address target) {
    require(sender != target, "This function is not self callable");
    _;
  }

  constructor(
    address[] memory defaultOperators
  ) public {
    _name = "Fiat Frenzy";
    _symbol = "FRNZY";
    _granularity = 1;

    _defaultOperators = defaultOperators;
    for (uint256 i = 0; i < _defaultOperators.length; i++) {
      _isDefaultOperator[_defaultOperators[i]] = true;
    }
  }

  function name() external view returns (string memory) {
    return _name;
  }

  function symbol() external view returns (string memory) {
    return _symbol;
  }

  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }
  
  function balanceOf(address holder) external view returns (uint256) {
    Account memory account = _accounts[holder];
    return account._balance;  
  }

  function granularity() external view returns (uint256) {
    return _granularity;
  }

  function defaultOperators() external view returns (address[] memory) {
    return _defaultOperators;
  }

  function isOperatorFor(
    address operator,
    address tokenHolder) public view returns (bool) {
    return (operator == tokenHolder
           || _authorizedOperators[operator][tokenHolder]
           || (_isDefaultOperator[operator] && !_revokedDefaultOperator[operator][tokenHolder]));
  }

  function authorizeOperator(address operator) notSelf(msg.sender, operator) external {
   if (_isDefaultOperator[operator]) {
     _revokedDefaultOperator[operator][msg.sender] = false;
   } else {
     _authorizedOperators[operator][msg.sender] = true;
   }
   emit AuthorizedOperator(operator, msg.sender);
  }
  
  function revokeOperator(address operator) notSelf(msg.sender, operator) external {
   if (_isDefaultOperator[operator]) {
     _revokedDefaultOperator[operator][msg.sender] = true;
   } else {
     _authorizedOperators[operator][msg.sender] = false;
   }
   emit RevokedOperator(operator, msg.sender);
  }

  function send(address to, uint256 amount, bytes calldata data) external {

  }

} 
