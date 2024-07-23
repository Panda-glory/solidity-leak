// SPDX-License-Identifier: MIT
pragma solidity ^0.4.26;
// 尝试去修改isComplete吧

contract att{
    function attract(address addr) public {
        array(addr).number_add(1);
        array(addr).isCompleted();
    }
}
contract array {
    bool public isComplete;//0
    uint public score;//1
    uint[] public prime_number;//2
    
    function number_add(uint _num) public {
        uint[] tmp;
        tmp.push(_num);
        prime_number=tmp;
    }

    function isCompleted() public {
        score = 0;
        if(isContract(msg.sender)){
            score += 25;
        }
        if(isComplete){
            score +=75;
        }
    }

    function isContract(address addr) private view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}