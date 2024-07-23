// SPDX-License-Identifier: MIT
pragma solidity 0.4.24;
contract test{
     struct User{
        string name;
        mapping(address => uint256)debts;
        uint256[] balances;
    }
    uint256[] public events;//0
    mapping(address => uint256) public borrows;//1
    string public contractName = "cuit is the best school in CN";//2
    mapping(address => User) users;//3
    function borrow(string memory _name,uint256 _debt)public payable{
        if (msg.value>0){
            User storage user = users[msg.sender];
            events.push(1);
            borrows[msg.sender]+=msg.value;
            user.name = _name;
            user.debts[msg.sender] = msg.value;
            user.balances.push(msg.value);
        }else{
            user.name = _name;
            user.debts[address(this)]=_debt;
            user.balances.push(0);
        }
    }
    function get(uint slot) public view returns(bytes32 ret){
        assembly {
            ret := sload(slot)
        }
    }
    function add() public {
        borrow("00000000000000000000000000", 0);
    }

}