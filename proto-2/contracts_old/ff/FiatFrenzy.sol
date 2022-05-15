pragma solidity 0.5.8;
import './Helpers.sol';

contract FiatFrenzy  {
  // Coin Meta
  string internal _name;
  string internal _symbol;
  uint256 internal _decimals;
  uint256 internal _totalSupply;
  uint256 internal _granularity;
  uint256 internal _wad;
  
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
  uint256 _outstandingInterest;
  // no dynamic sizing of memory arrays, this gets deleted before every mint
  uint256[] _digits;
  mapping (uint256 => bool) _usedPostIds;

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
    uint256 _expiry;
    bool _isApproved;
    uint256 _createdAt;
    uint256 _signedAt;
    uint256 _interest;
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

  event loanRepaid(
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


  function timeAdjustedRR(
    uint256 expiryDate
  ) public view returns(uint256) {
    // higher numbers further in time
    uint256 lengthOfTimeInS = expiryDate - now;
    uint256 dayInS = 3600*24;
    // i believe this floors, is this satisfactory on the edge?
    uint256 daysTillExpiry = lengthOfTimeInS / dayInS;
    
    if (daysTillExpiry < 365) {
      uint256 increment = _reserveRequirement / 365;
      return daysTillExpiry*increment;
    }
    return _reserveRequirement;
  }

  modifier isWithinReserveRatio(
    address lendor,
    uint256 amount
  ) {
    Account memory account = _accounts[lendor];
    uint256 currentRatio = Helpers.percent(account._liabilities + amount, account._balance, _decimals);
    require(currentRatio <= _reserveRequirement, "apologies, reserve requirement exceeded");
    _;
  }

  modifier isLoanOfferWithinReserveRatio(
    address lendor,
    uint256 amount,
    uint256 expiry
  ) {
    Account memory account = _accounts[lendor];
    uint256 currentRatio = Helpers.percent(account._liabilities + amount, account._balance, _decimals);
    require(currentRatio <= timeAdjustedRR(expiry), "apologies, reserve requirement exceeded");
    _;
  }

  constructor(
    address[] memory defaultOperators
  ) public {
    _name = "Fiat Frenzy";
    _symbol = "FREN";
    _granularity = 1;
    _decimals = 18;
    _wad = 10**_decimals;
    _reserveRequirement = Helpers.percent(11111460156937785151929026842503960837766832936, 17978720198565577104981084195586024127087428957, _decimals);
    _defaultOperators = defaultOperators;
    for (uint256 i = 0; i < _defaultOperators.length; i++) {
      _isDefaultOperator[_defaultOperators[i]] = true;
    }
    // some test coins, remove for prod
    uint256 testCoins = 100 * _wad;
    _accounts[msg.sender]._balance = testCoins;
    _totalSupply = testCoins;

  }
  
  function name() external view returns (string memory) {
    return _name;
  }

  function symbol() external view returns (string memory) {
    return _symbol;
  }

  function decimals() external view returns (uint256) {
    return _decimals;
  }

  function reserveRequirement() external view returns (uint256) {
    return _reserveRequirement;
  }

  
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  function outstandingInterest() external view returns (uint256) {
    return _outstandingInterest;
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


  function formGet(uint digit, uint factor) internal pure returns (uint) {
    string memory digitAsStr = Helpers.uintToString(digit);
    string memory digitsAsStr = '';
    uint i = 0;
    while (i < factor) {
      digitsAsStr = Helpers.append(digitsAsStr, digitAsStr);
      i++;
    }
   return Helpers.parseInt(digitsAsStr, 0);
  }
  event proof(
    uint256 amount
  );
  function proofOfMeme(address to, uint256 post) external returns (uint256) {
    require(_isDefaultOperator[msg.sender], 'executive fn only');
    require(_usedPostIds[post] == false, 'no using the same post twice');
    delete _digits;
    uint256 number = post;
    uint256 lastIndex = 0;
   
    while (number > 0) {
      uint256 digit = uint256(number % 10);
      number = number / 10;
      _digits.push(digit);
      lastIndex = _digits.length - 1;
    } 
    uint256 last = 0;
    uint256 getFactor = 1;
      for (uint256 i = 0; i < _digits.length; i++) {
        if (i == 0) {
          last = _digits[i];
        } else {
          if (last == _digits[i]) {
            getFactor++;
          } else {
            break;
          }
        }
    }
    uint256 amount = formGet(last, getFactor);
    operatorMint(to, amount*_wad);
    _usedPostIds[post] = true;
  }
 
  function _send(
    address to,
    address from,
    uint256 amount
  ) internal {
    require(to != address(0), 'no tokens to 0x0');
    Account storage senderAccount = _accounts[from];
    require(senderAccount._balance >= amount, "Insufficient Funds");
    Account storage recieverAccount = _accounts[to];

    senderAccount._balance -= amount;
    recieverAccount._balance += amount;

  } 
  function send(
    address to,
    uint256 amount,
    bytes calldata data
  ) isMultipleOf(amount)
  external {
    _send(to, msg.sender, amount);   
    emit Sent(msg.sender, to, amount, data); 
  }
  // transfer fn to make metamask happy
  function transfer(address _to, uint256 _value) external {
    _send(_to, msg.sender,  _value);
  }

  function offerLoan(
    address debtor,
    uint256 amount,
    uint256 expiry,
    uint256 interest
  ) isMultipleOf(amount)
    isLoanOfferWithinReserveRatio(
      msg.sender,
      amount,
      expiry
    )
  external {
    // minimum day
    require((expiry - now) > 3600*24, 'loans must be at least a 24h');
    Loan memory newLoan = Loan(amount, expiry, false, now, 0, interest);
    // _loans[lendor][debtor]
    _loans[msg.sender][debtor].push(newLoan);
    uint256 index = _loans[msg.sender][debtor].length;
    _loanIndicies[msg.sender][debtor].push(index);

    emit loanOffer(msg.sender, index, debtor);
  }
  
  function getLoanIndex(
    address lendor,
    address debtor
  ) external view returns (uint256) {
    uint256 index = _loanIndicies[lendor][debtor].length;
    return index;
  }

  function getLoan(
    address lendor,
    address debtor,
    uint256 index
  ) external view returns (uint256, uint256, bool, uint256) {
    Loan memory loan =  _loans[lendor][debtor][index - 1];  
    return (loan._principle, loan._createdAt, loan._isApproved, loan._interest);
  }

  function signLoan(
    address lendor,
    uint256 index
  ) isWithinReserveRatio(
      lendor,
      _loans[lendor][msg.sender][index - 1]._principle
  ) external {
    // state
    Loan storage loan = _loans[lendor][msg.sender][index - 1];
    Account storage lendorAccount = _accounts[lendor];
    Account storage debtorAccount = _accounts[msg.sender];
    
    // change balances
    debtorAccount._balance += loan._principle;
    debtorAccount._liabilities += loan._principle + loan._interest;

    lendorAccount._liabilities += loan._principle;
    lendorAccount._assets += loan._interest;
 
    loan._isApproved = true;
    loan._signedAt = now; 
    
    // change globals
    _totalSupply += loan._principle;
    _outstandingInterest += loan._interest;
    emit loanSign(lendor, index, msg.sender);
  }

  function getDebtIndex(
    address lendor
  ) external view returns (uint256) {
    return _loans[lendor][msg.sender].length;
  }

  function repayLoan(
    address lendor,
    uint256 index
  ) 
  external {
    Loan storage loan = _loans[lendor][msg.sender][index - 1];
    //require(now >= loan._expiry, 'loans must be expired before they are repaid');
    Account storage debtorAccount = _accounts[msg.sender];
    Account storage lendorAccount = _accounts[lendor];
    require(
      debtorAccount._balance >= loan._principle + loan._interest, 'insufficent funds'
    );

    _send(lendor, msg.sender, loan._interest);

    debtorAccount._balance -= loan._principle; 
    debtorAccount._liabilities -= loan._principle;
    
    lendorAccount._liabilities -= loan._principle;
    lendorAccount._assets -= loan._interest;
    
    loan._principle = 0;

    // globals
    _totalSupply -= loan._principle;
    _outstandingInterest -= loan._interest;
    emit loanRepaid(lendor, index, msg.sender);
  }
} 
