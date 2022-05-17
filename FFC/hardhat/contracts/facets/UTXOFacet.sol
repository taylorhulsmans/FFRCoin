pragma solidity ^0.8.0;

import { onlyOwner, UTXO } from '../libraries/LibAppStorage.sol';

import { AppStorage, LibAppStorage, Modifiers  } from '../libraries/LibAppStorage.sol';
contract UTXOFacet {
  function getId(address _to, bytes32 _input) returns (bytes32) {
    return keccak(block.number, msg.sender, _to, _input);
  }

  function create(address _to, uint256 _amount) external {
    AppStorage storage s = LibAppStorage.diamondStorage();
    bytes32 id = keccak256(block.number, msg.sender, _to);
    UTXO utxo = new UTXO(
      msg.sender, //origin
      0, //percent recycled
      _to, //owner
      _amount, //value
      bytes32(msg.sender), // createdby
      id,
    ); 

    s.utxos[id] = utxo;
    s.totalSupply += _value;
  }

  function spend(bytes32 _id, uint256 _amount, address _to) external {
    AppStorage storage s = LibAppStorage.diamondStorage();
    UTXO memory utxo = s.utxos[_id];
    require(msg.sender === utxo.owner, "cannot spend anothers utxo");
    require(utxo.value >= _amount, "cannot spend more than the value inside the box");
    delete s.utxos[_id];
    bytes32 id = getId(_to, _id);
    utxo spend1 = new UTXO(_to, _amount, _id, id);
    s.utxos[id] = spend1;
    //event
    //subspend
    if (_amount < utxo.value) {
      bytes32 utxo2 = getId(msg.sender, _id^bytes32(1));
      utxo spend2 = new UTXO(msg.sender, utxo.value - _amount, _id, utxo2);
      s.utxos[utxo2] = spend2;
      //spend
    }
    
  }
} 
