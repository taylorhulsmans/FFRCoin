pragma solidity 0.5.8;
import { IERC777Token } from './IERC777.sol';
contract FiatFrenzy is IERC777Token {
	string internal _name;
	string internal _symbol;
	uint256 internal _totalSupply;
	uint256 internal _granularity;

	address[] internal _defaultOperators;
	mapping(address => bool) internal _isDefaultOperator;
	mapping(address => mapping(address => bool)) internal _revokedDefaultOperator;
	mapping(address => mapping(address => bool)) internal _authorizedOperators;
	struct Account {
		uint256 _balance;
		uint256 _assets;
		uint256 _liabilities;
	}
	mapping (address => Account) _accounts;

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
					 || (_isDefaultOperator[operator] && _revokedDefaultOperator[operator][tokenHolder]));
	}
	
} 
