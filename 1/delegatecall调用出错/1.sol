pragma solidity ^0.5.0;
//1.成为owner
//2.商品价格修改为0
contract shop{
    goods public _goods;//0
    address public owner = address(this);//1
    uint256 public prize;//2
    uint256 public score;//3
    constructor()public{
        _goods = new goods("food",1000000 ether);//0
        prize = 1000000 ether;//2
    }
    function changePrice(uint256 amount)public{
      (bool success,) = address(_goods).delegatecall(abi.encodeWithSignature("setPrize(uint256)",amount));
       require(success,"delegatecall failed");
       require(score==0);
    }
}

contract goods{
    uint256 public prize;//0
    string public name;//1
    constructor(string memory _name,uint256 _prize)public{
        name = _name;//1
        prize = _prize;//0
    }
    function setPrize(uint256 amount)public {
        prize = amount;
    }
}

contract check is shop{
    function isCompleted()external{
        score=0;
        if(owner==msg.sender){
            score+=50;
        }
        if(prize==0){
            score+=50;
        }
    }
}