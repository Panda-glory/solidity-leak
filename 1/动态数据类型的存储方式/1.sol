//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/utils/StorageSlotUpgradeable.sol";
// 1.猜出string1.2.猜出string2
// 0x0000000000000000000000000000000000000000000000000000000000000000
// 0x0000000000000000000000000000000000000000000000000000000030303030
// 0x0000000000000000000000000000000000000000000000000000000000000001
// 0x3030303030303030303030303030303030303030303030303030303030303030
// 0x0000000000000000000000000000000000000000000000000000000000000003
// 0x0000000000000000000000000000000000000000000000000000000000303030
contract stringer{
    string private string1 = "cuit";//4
    string private string2 = "cuit, the best school of blockchain";//35
    uint256 public score;
    
    function setSlot(bytes32 slot,bytes32 value)public {
        require(slot !=bytes32(uint256(2)));
        StorageSlotUpgradeable.getBytes32Slot(slot).value = value;
    }
    function getstring() public view returns(bytes memory,uint256){
        bytes memory a = bytes(string1);
        return (a,a.length);
    }
    function getStorageAt(uint slot) public view returns (bytes32 ret) {
        assembly {
            ret := sload(slot)
        }
    }
    function isCompleted()public{
        score =0;
        bytes memory str1 = bytes(string1);
        for (uint i =0;i<str1.length;i++){
            if (str1[i]!=0){
                break;
            }
            if(score<50){
                score+=10;
            }
        }

        bytes memory str2 = bytes(string2);
        for (uint i =0;i<str2.length;i++){
            if (str2[i]!=0){
                break;
            }
            if(i==str2.length-1){
                score+=50;
            }
        }
    }
}