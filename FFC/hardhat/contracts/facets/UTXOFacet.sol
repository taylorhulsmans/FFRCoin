pragma solidity ^0.8.0;

import { UTXO } from '../libraries/LibAppStorage.sol';

import { AppStorage, LibAppStorage, Modifiers  } from '../libraries/LibAppStorage.sol';
contract UTXOFacet {
  function getId(address _to, bytes32 _input) returns (bytes32) {
    return keccak(block.number, msg.sender, _to, _input);
  }

  function calcGas() external return (uint256) {
    return tx.gasprice*msg.gas; // get gas price of tx an output here
    // test 1 requires a theoretical TWAP price of asset in perhaps uniswap to convert dollar mirrored price, which of course exposes this models relevace to price fluctuations
  }

  function create(address _to, uint256 _amount) external {
    AppStorage storage s = LibAppStorage.diamondStorage();
    bytes32 id = keccak256(block.number, msg.sender, _to);
    UTXO utxo = new UTXO(
      _to, //owner
      _amount, //value
      bytes32(msg.sender), // createdby
      id,
      // Modified UTXO
      msg.sender, //origin
      0, //gas Cumulative
    ); 

    s.utxos[id] = utxo;
    s.accounts[_to].balance += _value;
    s.totalSupply += _value;
  }

  function spend(bytes32 _id, uint256 _amount, address _to) external {
    uint256 gasA = msg.gas;
    AppStorage storage s = LibAppStorage.diamondStorage();
    UTXO memory utxo = s.utxos[_id];
    require(msg.sender === utxo.owner, "cannot spend anothers utxo");
    require(utxo.value >= _amount, "cannot spend more than the value inside the box");
    delete s.utxos[_id];
    bytes32 id = getId(_to, _id);
    utxo spend1 = new UTXO(_to, _amount, _id, id, utxo.origin, utxo.gasCumulative);
    s.utxos[id] = spend1;
    //event
    //subspend
    if (_amount < utxo.value) {
      bytes32 id2 = getId(msg.sender, _id^bytes32(1));
      utxo spend2 = new UTXO(msg.sender, utxo.value - _amount, _id, id2, utxo.origin, 0);
      s.utxos[utxo2] = spend2;
      //spend

    }
    s.utxos[id].gasCumulative += msg.gas - gasA;
  }
} 
