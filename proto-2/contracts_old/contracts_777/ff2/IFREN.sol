pragma solidity ^0.7.1;


interface IFREN {

      /*

       (1 - RL)*M = 1
       (1 - RL) = 1 / M
       - RL = 1 / M - 1
        RL = 1 - (1 /M)
      */
  
/* (1 / rr)*total_supply = total_supply + diff
* internal system tracts 1 - rr for easier comparison in modifiers
* system not 100% sensitive, moves at 1 / 24 th 
*/

// the reserve Multiplier approximates the anticipated growth in Fren supply given a reserve ratio
// FREN adjusts this reserve ratio to generate positive or negative divergence in the money field
// to maintain orbit around the 1:1 peg

}
