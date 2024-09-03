// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract JoKenPo2 {
    enum Options{NONE, ROCK, PAPER, SCISSORS} //0, 1, 2, 3

    Options private choice1 = Options.NONE;
    address private player1;
    string  public result = "";
    uint public qtdVitorias = 0;
    address payable private immutable owner;

    struct Player {
        address wallet;
        uint32 wins;
    }

    Player[] public players;

    constructor() {
        owner = payable(msg.sender);
    }

    //qtd de vitorias

    function updateWinner(address winner) private{
        for(uint i = 0; i < players.length; i++) {
            if(players[i].wallet == winner)
            players[i].wins++;
                return;
        }
        players.push(Player(winner, 1));
    }

    function finishiGame(string memory newResult, address winner) private {
        address contractAddress = address(this);
        payable(winner).transfer((contractAddress.balance / 100) * 90);
        owner.transfer(contractAddress.balance);
        updateWinner(winner);
            
        

        result = newResult;
        player1 = address(0);
        choice1 = Options.NONE;
    }

    function getBalance() public view returns(uint) {
        require(owner == msg.sender, "You dont have permission");
        return address(this).balance;
    }

    function play(Options newChoice) public payable  {
        require(newChoice != Options.NONE, "Invalid Choice");
        require(player1 != msg.sender, "Wait the another player...");
        require(msg.value >= 0.01 ether, "Invalid bit");

        if(choice1 == Options.NONE) {
            player1 = msg.sender;
            choice1 = newChoice;
            result = "Player 1 choice his/her option. Waiting for player 2";
        } else if(choice1 == Options.ROCK && newChoice == Options.SCISSORS) {
            finishiGame("Player 1 WON", player1);
        } else if(choice1 == Options.PAPER && newChoice == Options.ROCK) {
            finishiGame("Player 1 WON", player1);
        } else if(choice1 == Options.SCISSORS && newChoice == Options.PAPER) {
            finishiGame("Player 1 WON", player1);
        } else if(choice1 == Options.SCISSORS && newChoice == Options.ROCK) {
            finishiGame("Player 2 WON", msg.sender);
        } else if(choice1 == Options.ROCK && newChoice == Options.PAPER) {
            finishiGame("Player 2 WON", msg.sender);
        } else if(choice1 == Options.PAPER && newChoice == Options.SCISSORS) {
            finishiGame("Player 2 WON", msg.sender);
        } else {
        result = "Draw game, prize doubled";
        player1 = address(0);
        choice1 = Options.NONE;
        }
    }

    function getLeaderBorder() public view returns(Player[] memory) {
        if(players.length < 2) return players;

        Player[] memory arr = new Player[](players.length);

        for(uint i=0; i < players.length; i++) {
            arr[i] = players[i];
        }
        for(uint i = 0; i < arr.length - 1; i++) {
            for(uint j = 1; j < arr.length; j++) {
                if(arr[i].wins < arr[j].wins) {
                    Player memory change = arr[i];
                    arr[i] = arr[j];
                    arr[j] = change;
                }
            }
        }
        return arr;
    }
}