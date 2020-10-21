pragma solidity ^0.7.1;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';

import './Helpers.sol';
import './DecimalMath.sol';
import * as Stub from './Stub.sol';

contract FREN is ERC20, ReentrancyGuard {
  using SafeMath for uint256;
  
  /* Integrations
  *
  *
  */
  Stub.sDaiToken daiToken;
  Stub.sUniswapV2Factory uniswapV2Factory;
  Stub.sUniswapV2Router02 uniswapV2Router02;
  Stub.sSlidingWindowOracle slidingWindowOracle;
  address public uniswapPairAddress;
  
  /* State
  *
  *
  */

  // an account may not loan past (Assets / Liabilities)*(credibilityPoints/TotalCredibilityPoints)
  // this is their share of money printing, a proportion of the global reserve requirement whose size is based on being atop the leaderboard
  // is fixed point with 18 decimals
  uint public reserveRequirement;
  uint public totalCredibilityPoints;

  struct Account {
    uint256 credibilityPoints;
    //uint256 newAccountOutflowRestrictor;
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
    daiToken = Stub.sDaiToken(daiAddress);
    uniswapV2Factory = Stub.sUniswapV2Factory(uniswapV2FactoryAddress);
    uniswapPairAddress = uniswapV2Factory.createPair(daiAddress, address(this));
    slidingWindowOracle = Stub.sSlidingWindowOracle(slidingWindowOracleAddress);
    _mint(msg.sender, initialAmount);
    reserveRequirement = DecimalMath.unit(ERC20.decimals());

  }

  function daiReserve() public view returns (uint256){
    return daiToken.balanceOf(address(this));
  }

  /* Reserve req Mod
  *
  */

  function update() internal {
    /* (1 / rr)*total_supply = total_supply + diff
    * internal system tracts 1 - rr for easier comparison in modifiers
    * system not 100% sensitive, moves at 1 / 24 th 
    */

    // the reserve Multiplier approximates the anticipated growth in Fren supply given a reserve ratio
    // FREN adjusts this reserve ratio to generate positive or negative divergence in the money field
    // to maintain orbit around the 1:1 peg
    uint unity = DecimalMath.unit(ERC20.decimals());
    // M = 1 - ( 1 / rr)
    uint reserveMultiplier_t_0 = DecimalMath.subd(
      unity,
      DecimalMath.divd(
        unity,
        reserveRequirement
      )
    );
    
    (
      uint fren_reserve,
      uint dai_reserve,
      uint last_block_timestap
    ) = Stub.sUniswapV2Pair(
      Helpers.pairFor(
        address(uniswapV2Factory),
        address(daiToken),
        address(this)
      )
    ).getReserves();
    if (fren_reserve <= dai_reserve) {
     uint difference = dai_reserve.sub(fren_reserve);
     uint reserveMultiplier_t_1 = DecimalMath.divd(
       difference,
       ERC20.totalSupply()
     ) + unity;
     uint reserveMulDiff = DecimalMath.subd(
       reserveMultiplier_t_1,
       reserveMultiplier_t_0
     );
     uint delta = DecimalMath.divd(
       reserveMulDiff,
       DecimalMath.muld(24, unity)
     );
     reserveMultiplier_t_1 = DecimalMath.subd(
      reserveMultiplier_t_1,
      delta
     );
     reserveRequirement = DecimalMath.subd(
       unity,
       DecimalMath.divd(
        unity,
        reserveMultiplier_t_1
       )
     );
    } else {

     uint difference = fren_reserve.sub(dai_reserve);
     uint reserveMultiplier_t_1 = DecimalMath.divd(
       difference,
       ERC20.totalSupply()
     ) + unity;
     uint reserveMulDiff = DecimalMath.subd(
       reserveMultiplier_t_0,
       reserveMultiplier_t_1
     );
     uint delta = DecimalMath.divd(
       reserveMulDiff,
       DecimalMath.muld(24, unity)
     );
     reserveMultiplier_t_1 = DecimalMath.addd(
      reserveMultiplier_t_1,
      delta
     );
     reserveRequirement = DecimalMath.addd(
       unity,
       DecimalMath.divd(
        unity,
        reserveMultiplier_t_1
       )
     );
    }
    

     /* using oracle weighted prices is probably alot smarter than the state of the pool at whatever position the miner wants it in a block
    (uint timestamp_t_1, uint fren_t_1, uint dai_t_1 ) = slidingWindowOracle.pairObservations(uniswapPairAddress, pairIndex);
    int pair_t_1 = Fixidity.divide(int(fren_t_1), int(dai_t_1));
    
    (uint timestamp_t_0, uint fren_t_0, uint dai_t_0 ) = slidingWindowOracle.pairObservations(uniswapPairAddress, pairIndex--);
    int pair_t_0 = Fixidity.divide(int(fren_t_0), int(dai_t_0));
    if (pair_t_1 >= pair_t_0) { // (+)
      uint256 frenShortage = 
      // changeReserveRatio to send back to 1


      uint multiplier = Helpers.percent(1 * ERC20.decimals(), reserveRequirement, ERC20.decimals());
    } else { // (-) 
      
    }

    */
    // why use oracle prices when i can query reserve of liquidity pool?
    //uint8 pairIndex = slidingWindowOracle.observationIndexOf(block.timestamp);
    //slidingWindowOracle.update(address(this), address(daiToken));
    
    //if (pairIndex == 0) { return; } // pass first delta
    
    // determine price vector t_0 and t_1
    // if (+)
    // reduce reserve requirement so the money multiplier re balances to 1:1
    // if (-)
    // tighten reserve requirement to the mony multiple re balances to 1:1

  }
 
    function getReserves() public view returns (uint fren, uint dai, uint last_timestamp) {
    (
      uint fren,
      uint dai,
      uint last_block_timestamp
    ) = Stub.sUniswapV2Pair(
      Helpers.pairFor(
        address(uniswapV2Factory),
        address(daiToken),
        address(this)
      )
    ).getReserves();
    return (fren, dai, last_block_timestamp);
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
      uint256 increment = reserveRequirement / 365;
      return daysTillExpiry*increment;
    }
    return reserveRequirement;
  }

  modifier isWithinReserveRatio(
    address lendor,
    uint256 amount
  ) {
    Account memory account = _accounts[lendor];
    uint proportion = DecimalMath.divd(
      account.credibilityPoints,
      totalCredibilityPoints
    );
    uint256 balance = balanceOf(lendor);
    uint currentRatio = DecimalMath.divd(
      account.liabilities + amount,
      balance
    );
    uint activeRequirement = DecimalMath.muld(
      proportion,
      reserveRequirement
    );
    require(currentRatio <= activeRequirement, "apologies, reserve requirement exceeded");
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

    slidingWindowOracle.update(address(daiToken), address(this));
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
    debtorAccount.credibilityPoints.add(loan.principle + loan.interest);
    totalCredibilityPoints.add(loan.principle + loan.interest);
    
    lendorAccount.assets.sub(loan.principle + loan.interest);
    lendorAccount.liabilities.sub(loan.principle);
    lendorAccount.credibilityPoints.add(loan.principle + loan.interest);
    totalCredibilityPoints.add(loan.principle + loan.interest);
    
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
