pragma solidity ^0.8.0;

import "../levels/MagicNum.sol";
import "../levels/MagicNumFactory.sol";

contract MagicNumAttack {
    constructor(address payable addr,address factory) {
        MagicNum(addr).setSolver(address(this));
        // MagicNumFactory(factory).validateInstance(addr,msg.sender);
    }
    function whatIsTheMeaningOfLife() external view returns (bytes32){
        return 0x000000000000000000000000000000000000000000000000000000000000002a;
    }
}