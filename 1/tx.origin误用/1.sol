//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
//想想怎么能夺取owner，拿走合约余额
contract Pulling{
   
    address public owner;
    uint256 public score;
     
    function changeOwner() public  {
        require(address(this).balance>=1000 ,"Not enough money");  
        require(tx.origin != msg.sender);   
        owner=msg.sender;
    }
    function isComplete()public {
       score=0;
       if(owner!=address(0)){
           score+=50;
       }
       if(address(this).balance>0){
           score+=50;
       }
    }
}