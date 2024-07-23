// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
import "./1.sol";
// 得到尽可能多的token
contract Attract{
    Cal cal;
    constructor(Cal addr)public {
        cal = addr;
    }
    function attract() public payable {
        // cal.buy{value : 0.01 ether}();
        cal.transfer(address(cal), 1);
        cal.isComplete();
    }
}