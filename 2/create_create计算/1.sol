pragma solidity ^0.8.0;
// 1.调用depoly部署合约，30分 2.算出要部署的合约地址并提前发送0.001ether 70分
contract found{
    bool public resove = false;
    
    constructor(){
        if(address(this).balance >= 0.001 ether){
            resove = true;
        }  
    }
    
    function getResove() public view returns(bool){
        return resove;
    }
}
contract check{
    found public target;
    uint public score;
    
    function depoly(bytes32 _salt) public returns(address){
        target = new found{salt: _salt}();
        return address(target);
    }
    function isCompleted() public {
        score = 0;
        if(address(target) != address(0)){
            score += 30;
        }
        if(target.getResove()){
            score += 70;
        }
    }
}
contract getnewcontract{
    bytes public  creatcode1 = type(found).creationCode;
    bytes32 public g = keccak256(creatcode1);
    constructor() payable public {}
    function getaddress(address target,bytes32 salt) public{
        // bytes memory creatcode = type(found).creationCode;
        address a = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            target,
            salt,
            keccak256(creatcode1)
        )))));
         selfdestruct(payable(a));
    }
}
contract att{
    check che;
    constructor(check addr) {
        che = addr;
    }
    bytes public  creatcode1 = type(found).creationCode;
    bytes32 public g = keccak256(creatcode1);
    bytes32 public creatcode2;
    function attract(bytes32 salt) public payable {
        getnewcontract A = new getnewcontract{value: 0.001 ether}();
        A.getaddress(address(che),salt);
        che.depoly(salt);
        che.isCompleted();
    }
    function getaddress(address target,bytes32 salt) public returns(address a){
        bytes memory creatcode = type(found).creationCode;
        creatcode2 = keccak256(creatcode);
        a = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            target,
            salt,
            keccak256(creatcode)
        )))));
    }
}


// 0x0000000000000000000000000000000000000000000000000000000000000000


contract solve{
    constructor() public payable{}
    
    function getAddressAndSend(bytes32 _salt,address addr) public {
        require(address(this).balance >= 0.001 ether);
        bytes memory bytecode = type(found).creationCode;
        bytes32 hash = keccak256(
        abi.encodePacked(
            bytes1(0xff),
            addr,
            _salt,
            keccak256(bytecode)
        )
    );
        address _add = address(uint160(uint256(hash)));
        selfdestruct(payable(_add));
        
    }
}
// 1000000000000000
//传入salt  工厂合约的地址就可以
contract foundattack{
    
    bytes32 public salt;
    address public target;

    constructor(bytes32 _salt,address _target) public payable{
        salt = _salt;
        target = _target;
    }

    function attack() public payable{
        solve add1 = new solve{value: 0.001 ether}();
        add1.getAddressAndSend(salt,target);
        check(target).depoly(salt);
        check(target).isCompleted();

    }
}
