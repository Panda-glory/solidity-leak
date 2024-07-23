pragma solidity ^0.4.26;
// 尝试去修改isComplete吧
import "./1.sol";
contract Attract{
    array arr;
    constructor(array addr) public  {
        arr = addr;
    }
    function attract() public {
        arr.number_add(uint8(1));
        arr.isCompleted();
    }
}