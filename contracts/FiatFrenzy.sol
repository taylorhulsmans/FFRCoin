pragma solidity 0.5.8;
import { IFiatFrenzy} from './IFiatFrenzy.sol';
import './Helpers.sol';
contract FiatFrenzy is IFiatFrenzy {
  // Coin Meta
  string internal _name;
  string internal _symbol;
  uint256 internal _totalSupply;
  uint256 internal _granularity;
  
  event Sent(
    address indexed from,
    address indexed to,
    uint256 amount,
    bytes data
  );
  
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
  uint256 _reserveRequirement;

  struct Account {
    // The number of tokens an account has
    uint256 _balance;
    // The number of positive loan
    uint256 _assets;
    // The number of negative loan
    uint256 _liabilities;
  }
  mapping (address => Account) _accounts;
  
  struct Loan {
    uint256 _principle;
    uint256 _time;
    bool _isApproved;
  }
  // _loans[lendor][debtor]
  mapping (address => mapping (address => Loan[])) _loans;
  // indexer, using push to guarantee uniques
  mapping (address => mapping (address => uint256[])) _loanIndicies;

  event Minted(
    address indexed _operator,
    address indexed _to,
    uint256 _amount
  );

  event loanOffer(
    address indexed _lendor,
    uint256 indexed _index,
    address indexed _debtor
  );

  event loanSign(
    address indexed _lendor,
    uint256 indexed _index,
    address indexed _debtor
  );

  modifier notSelf(address sender, address target) {
    require(sender != target, "This function is not self callable");
    _;
  }

  modifier isMultipleOf(uint256 amount) {
    require(amount % _granularity == 0, 'math warning');
    _;
  }

  modifier isWithinReserveRatio(
    address sender,
    uint256 amount
  ) {
    Account memory account = _accounts[sender];
    uint256 currentRatio = Helpers.percent(account._liabilities + amount, account._assets + account._balance, 9);
    require(currentRatio <= _reserveRequirement, "apologies, reserve requirement exceeded");
    _;
  } 

  constructor(
    address[] memory defaultOperators
  ) public {
    _name = "Fiat Frenzy";
    _symbol = "FRNZY";
    _granularity = 1;

    _reserveRequirement = Helpers.percent(17167680177565, 27777890035288, 9);
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
  
  function assetsOf(address holder) external view returns (uint256) {
    Account memory account = _accounts[holder];
    return account._assets;  
  }

  function liabilitiesOf(address holder) external view returns (uint256) {
    Account memory account = _accounts[holder];
    return account._liabilities;  
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

 
  function operatorMint(address to, uint256 amount) isMultipleOf(amount) public payable {
    require(_isDefaultOperator[msg.sender], 'executive function only');
    _accounts[to]._balance += amount;
    
    emit Minted(msg.sender, to, amount);
  }
  
  function send(
    address to,
    uint256 amount,
    bytes calldata data
  ) isMultipleOf(amount)
    isWithinReserveRatio(msg.sender, amount)
  external {
    require(to != address(0), 'no tokens to 0x0');
    Account storage senderAccount = _accounts[msg.sender];
    require(senderAccount._balance >= amount, "Insufficient Funds");
    Account storage recieverAccount = _accounts[to];

    senderAccount._balance -= amount;
    recieverAccount._balance += amount;

    emit Sent(msg.sender, to, amount, data); 
  }

  function offerLoan(
    address debtor,
    uint256 amount
  ) isMultipleOf(amount)
    isWithinReserveRatio(msg.sender, amount)
  public {
    Loan memory newLoan = Loan(amount, now, false);
    // _loans[lendor][debtor]
    _loans[msg.sender][debtor].push(newLoan);
    uint256 index = _loans[msg.sender][debtor].length;
    _loanIndicies[msg.sender][debtor].push(index);

    emit loanOffer(msg.sender, index, debtor);
  }
  
  function getLoanIndex(
    address lendor,
    address debtor
  ) public view returns (uint256) {
    uint256 index = _loanIndicies[lendor][debtor].length;
    return index;
  }

  function signLoan(
    address lendor,
    uint256 index
  ) public {
    Loan storage loan = _loans[lendor][msg.sender][index - 1];
    Account storage lendorAccount = _accounts[lendor];
    Account storage debtorAccount = _accounts[msg.sender];
    
    debtorAccount._balance += loan._principle;
    debtorAccount._liabilities += loan._principle;

    lendorAccount._liabilities += loan._principle;
    lendorAccount._assets += loan._principle;
    
    loan._isApproved = true;

    emit loanSign(lendor, index, msg.sender);
  }
} 
