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

    function uintToString(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    function append(string memory a, string memory b) internal pure returns (string memory) {

        return string(abi.encodePacked(a, b));

    }

    function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
        bytes memory bresult = bytes(_a);
        uint mint = 0;
        bool decimals = false;
        for (uint i = 0; i < bresult.length; i++) {
            if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
                if (decimals) {
                   if (_b == 0) {
                       break;
                   } else {
                       _b--;
                   }
                }
                mint *= 10;
                mint += uint(uint8(bresult[i])) - 48;
            } else if (uint(uint8(bresult[i])) == 46) {
                decimals = true;
            }
        }
        if (_b > 0) {
            mint *= 10 ** _b;
        }
        return mint;
    }
}
