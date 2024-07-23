// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
//通过构造data，去获取flag

contract Cake {
    uint256 public score;
    bool public flag;
    function cake(uint a, uint32 b) public {
        require(msg.sender == address(this), "You are not allowed");
        flag = true;
    }

    function cake(uint120 a, uint32 b) public {
        require(msg.sender == address(this), "You are not allowed");
    }

    function cake(uint a, uint160 b) public {
        require(msg.sender == address(this), "You are not allowed");
    }

    function dosome(bytes memory data) external {
        address(this).call(data);
    }

    function isCompleted() public {
        score = 0;
        if(flag){
            score = 100;
        }
    }

}