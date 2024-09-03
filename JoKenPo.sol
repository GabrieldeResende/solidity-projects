// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


contract JoKenPo {
    // 1 = Rock, 2 = Paper, 3 = Scissor
    string public choicePlayer1;
    string status = "";

        function compare(string memory str1, string memory str2) private pure returns (bool){
            bytes memory arrA = bytes(str1);
            bytes memory arrB = bytes(str2);
        return arrA.length == arrB.length && keccak256(arrA) == keccak256(arrB);
    }

    function choose(string memory newChoice) public {
        require(compare(newChoice, "rock") || compare(newChoice, "paper") || compare(newChoice, "scissor"), "You must choose rock, paper or scisor");
        choicePlayer1 = newChoice;
    }

    function getRandomChoice() public view returns(string memory) {
        uint256 randomValue = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, block.number)));

        uint256 choiceIndex = randomValue % 3;

        if(choiceIndex == 0) {
            return "rock";
        } else if(choiceIndex == 1) {
            return "paper";
        } else {
            return "scissor";
        }
    }

    function play() view public returns(string memory)  {
        if(compare(choicePlayer1, "rock") && compare(getRandomChoice(), "paper")) {
            return "CPU WIN";
        } else if(compare(choicePlayer1, "paper") && compare(getRandomChoice(), "scissor")) {
            return "CPU WIN";
        } else if(compare(choicePlayer1, "scissor") && compare(getRandomChoice(), "rock")) {
            return "CPU WIN";
        } else {
            return "Player WIN";
        }
    }
}