pragma solidity ^0.7.1;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import './Helpers.sol';

interface DaiToken {
    function transfer(address dst, uint wad) external returns (bool);
    function balanceOf(address guy) external view returns (uint);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface StubUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface StubUniswapV2Router02 {
  function addLiquidity(
  address tokenA,
  address tokenB,
  uint amountADesired,
  uint amountBDesired,
  uint amountAMin,
  uint amountBMin,
  address to,
  uint deadline
) external returns (uint amountA, uint amountB, uint liquidity);
}

interface StubSlidingWindowOracle {
  function update(address tokenA, address tokenB) external;
}

contract DaiMock is ERC20 {
  constructor(uint256 initialSupply) ERC20('Silver', 'SLV') {
    _mint(msg.sender, initialSupply);
  }
}

contract FREN is ERC20, ReentrancyGuard {
  using SafeMath for uint256;
  
  /* Integrations
  *
  *
  */
  DaiToken daiToken;
  address daiAddress;

  StubUniswapV2Factory uniswapV2Factory;
  StubUniswapV2Router02 uniswapV2Router02;
  StubSlidingWindowOracle slidingWindowOracle;
  address uniswapPairAddress;
  
  /* State
  *
  *
  */
  struct Account {
    uint256 reserveRequirement;
    uint256 newAccountOutflowRestrictor;
    uint256 assets;
    uint256 liabilities;
    uint256 outstandingInterest;
  }
  mapping (address => Account) _accounts;

  struct Loan {
    uint256 principle;
    uint256 expiry;
    bool isApproved;
    uint256 signedAt;
    uint256 createdAt;
    uint256 interest;
  }
  // _loans[lendor][debtor]
  mapping (address => mapping (address => Loan[])) _loans;
  mapping (address => mapping (address => uint256[])) _loanIndicies;

  /* Events
  *
  *
  */
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

  /* Constructor
  *
  */
  constructor(
    uint256 initialAmount,
    address daiAddress,
    address uniswapV2FactoryAddress,
    address uniswapV2Router02Address,
    address slidingWindowOracleAddress
  )
  ERC20(
    'Federal Reserve Everyone Network',
    'FREN'
  )
  {
    daiToken = DaiToken(daiAddress);
    daiAddress = daiAddress;
    uint256 dai = daiToken.balanceOf(address(this));
    _mint(msg.sender, initialAmount);
    uniswapV2Factory = StubUniswapV2Factory(uniswapV2FactoryAddress);
    uniswapPairAddress = uniswapV2Factory.createPair(daiAddress, address(this));
    slidingWindowOracle = StubSlidingWindowOracle(slidingWindowOracleAddress);

  }

  function daiReserve() public view returns (uint256){
    return daiToken.balanceOf(address(this));
  }

  /* Reserve req Mod
  *
  */

  function update() internal {
    slidingWindowOracle.update(daiAddress, address(this));

  }
 
  function timeAdjustedRR(
    address account,
    uint256 expiryDate
  ) public view returns(uint256) {
    Account memory relevantAccount = _accounts[account];
    // higher numbers further in time
    uint256 lengthOfTimeInS = expiryDate - block.timestamp;
    uint256 dayInS = 3600*24;
    // i believe this floors, is this satisfactory on the edge?
    uint256 daysTillExpiry = lengthOfTimeInS / dayInS;
    
    if (daysTillExpiry < 365) {
      uint256 increment = relevantAccount.reserveRequirement / 365;
      return daysTillExpiry*increment;
    }
    return relevantAccount.reserveRequirement;
  }

  modifier isWithinReserveRatio(
    address lendor,
    uint256 amount
  ) {
    Account memory account = _accounts[lendor];
    uint256 balance = balanceOf(lendor);
    uint256 currentRatio = Helpers.percent(account.liabilities + amount, balance, 18);
    require(currentRatio <= account.reserveRequirement, "apologies, reserve requirement exceeded");
    _;
  }

  modifier isLoanOfferWithinReserveRatio(
    address lendor,
    uint256 amount,
    uint256 expiry
  ) {
    Account memory account = _accounts[lendor];
    uint256 balance = balanceOf(lendor);
    uint256 currentRatio = Helpers.percent(account.liabilities + amount, balance, 18);
    require(currentRatio <= timeAdjustedRR(lendor, expiry), "apologies, reserve requirement exceeded");
    _;
  }

  /* Overrides
  *
  */
 
  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override { 

    slidingWindowOracle.update(daiAddress, address(this));
  }


  /* Loans
  *
  */
 
  function offerLoan(
    address debtor,
    uint256 amount,
    uint256 expiry,
    uint256 interest
  ) isLoanOfferWithinReserveRatio(
      msg.sender,
      amount,
      expiry
    )
  external {
    // minimum day
    require((expiry - block.timestamp) > 3600*24, 'loans must be at least a 24h');
    Loan memory newLoan = Loan(amount, expiry, false, block.timestamp, 0, interest);
    // _loans[lendor][debtor]
    _loans[msg.sender][debtor].push(newLoan);
    uint256 index = _loans[msg.sender][debtor].length;
    _loanIndicies[msg.sender][debtor].push(index);

    emit loanOffer(msg.sender, index, debtor);
  }
  
  function signLoan(
    address lendor,
    uint256 index
  ) isWithinReserveRatio(
      lendor,
      _loans[lendor][msg.sender][index - 1].principle
  ) external {
    // state
    Loan storage loan = _loans[lendor][msg.sender][index - 1];
    Account storage lendorAccount = _accounts[lendor];
    Account storage debtorAccount = _accounts[msg.sender];
    
    // change balances
    debtorAccount.liabilities.add(loan.principle + loan.interest);
    lendorAccount.assets.add(loan.principle + loan.interest);
    lendorAccount.liabilities += loan.principle;
 
    loan.isApproved = true;
    loan.signedAt = block.timestamp; 
    
    _mint(msg.sender, loan.principle);
    // change globals
    //_outstandingInterest += loan.interest;

    slidingWindowOracle.update(daiAddress, address(this));
    emit loanSign(lendor, index, msg.sender);
  }
  
  function repayLoan(
    address lendor,
    uint256 index
  ) 
  external {
    Loan storage loan = _loans[lendor][msg.sender][index - 1];
    //uncommented for testing purpose
    //require(block.timestamp >= loan.expiry, 'loans must be expired before they are repaid');
    Account storage debtorAccount = _accounts[msg.sender];
    uint256  debtorBalance = balanceOf(msg.sender);
    Account storage lendorAccount = _accounts[lendor];
    require(
      debtorBalance >= loan.principle + loan.interest, 'insufficent funds'
    );

    _transfer(msg.sender, lendor, loan.interest);
    _burn(msg.sender, loan.principle);
    debtorAccount.liabilities.sub(loan.principle + loan.interest);
    lendorAccount.assets.sub(loan.principle + loan.interest);
    lendorAccount.liabilities.sub(loan.principle);
    
    //_outstandingInterest -= loan.interest;
    emit loanRepaid(lendor, index, msg.sender);
  }

  function assetsOf(address holder) external view returns (uint256) {
    Account memory account = _accounts[holder];
    return account.assets;  
  }

  function liabilitiesOf(address holder) external view returns (uint256) {
    Account memory account = _accounts[holder];
    return account.liabilities;  
  }



}
