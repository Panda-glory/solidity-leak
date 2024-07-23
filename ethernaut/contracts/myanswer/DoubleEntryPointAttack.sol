// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../levels/DoubleEntryPoint.sol";

contract DoubleEntryPointAttack is IDetectionBot{
    CryptoVault public cry;
    DoubleEntryPoint public dou;
    
    function att(address addr) public {
        dou = DoubleEntryPoint(addr);
        cry = CryptoVault(dou.cryptoVault());
        Forta(dou.forta()).setDetectionBot(address(this));
    }
    function handleTransaction(address user, bytes calldata /* msgData */) external override { 
    // extract sender from calldata
    address origSender;
    assembly {
      origSender := calldataload(0xa8)
    }
    // raise alert only if the msg.sender is CryptoVault contract
    if (origSender == address(cry)) {
      Forta(msg.sender).raiseAlert(user);
    }
  }
}