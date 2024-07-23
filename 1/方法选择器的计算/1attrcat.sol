pragma solidity ^0.6.0;
import "./1.sol";
contract Attract{
    Cake cake;
    constructor(Cake addr) public {
        cake = addr;
    }
    bytes data = abi.encodeWithSignature("cake(uint256,uint32)");
    function attract() public {
        cake.dosome(data);
    } 
}