pragma solidity ^0.8.0;

import { UTXO } from '../libraries/LibAppStorage.sol';

import { AppStorage, LibAppStorage, Modifiers  } from '../libraries/LibAppStorage.sol';

contract OracleFacet {
  // Oracle Facet adjusts the global fractional reserve emission rate
  // FFC is floored to a basket of stables, positive demand releases
  // the the ability for actors to print dollars as loans
  // naturally this decreases the price as participants print dollars as loans
  // it is the hope that over time the price returns as loans are repaid and these loan principles are burned.

  // Uniswap v3 pricepool fetch (mock4now)
  // basic policy expansion tool (same v2 style target money multiplier so that the max money printed collects demand back to 1:1 backing)

  

}
