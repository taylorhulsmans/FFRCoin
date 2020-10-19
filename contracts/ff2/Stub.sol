pragma solidity ^0.7.1;

interface DaiToken {
    function transfer(address dst, uint wad) external returns (bool);
    function balanceOf(address guy) external view returns (uint);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface UniswapV2Pair {
  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

interface UniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface UniswapV2Router02 {
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

interface SlidingWindowOracle {
  function pairObservations(address swap, uint8 index) external view returns (uint256 timestamp, uint256 cumulativeP0, uint256 cumulativeP1);
  function observationIndexOf(uint timestamp) external view returns (uint8 index);
  function update(address tokenA, address tokenB) external;
}
