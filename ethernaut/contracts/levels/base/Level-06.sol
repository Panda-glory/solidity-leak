// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import './Ownable-06.sol';

abstract contract Level is Ownable {
  function createInstance(address _player) virtual public payable returns (address);
  function validateInstance(address payable _instance, address _player) virtual public returns (bool);
}
