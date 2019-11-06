pragma solidity 0.5.8;

library Helpers {

		function percent(
			uint numerator,
		 	uint denominator,
		 	uint precision
		) public pure returns(uint quotient) {
			
		// caution, check safe-to-multiply here
		uint _numerator  = numerator * 10 ** (precision+1);
		// with rounding of last digit
		uint _quotient =  ((_numerator / denominator) + 5) / 10;
		return ( _quotient);
	}

	// the reserve requirement, phi - 1 or (1 / phi),
	// will be amalgamated into the annum interest
	// Loan prepayment will be functionally tapered to the annum
	// so that only 1
}
