// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "OpenZeppelin-code/openzeppelin-contracts/contracts/access/Ownable.sol";

abstract contract Level is Ownable {
  function createInstance(address _player) virtual public payable returns (address);
  function validateInstance(address payable _instance, address _player) virtual public returns (bool);
}
