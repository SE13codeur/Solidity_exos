// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Token.sol";

contract GuessingGame is Ownable {
    struct Game {
        string word;
        string clue;
        address admin;
        address winner;
        mapping(address => bool) playedMap;
        bool finished;
    }

    mapping(address => Game) public games;

    function createGame(string memory _word, string memory _clue, address _admin) external onlyOwner {
        Game storage game = games[msg.sender];
        _initializeGame(game, _word, _clue, _admin);
    }

    function _initializeGame(
        Game storage game,
        string memory _word,
        string memory _clue,
        address _admin
    ) internal {
        game.word = _word;
        game.clue = _clue;
        game.admin = _admin;
    }

    function _setGameProperty(string memory _property, string memory _value) internal {
        Game storage game = games[msg.sender];

        if (keccak256(abi.encodePacked(_property)) == keccak256(abi.encodePacked("word"))) {
            game.word = _value;
        } else if (keccak256(abi.encodePacked(_property)) == keccak256(abi.encodePacked("clue"))) {
            game.clue = _value;
        } else if (keccak256(abi.encodePacked(_property)) == keccak256(abi.encodePacked("admin"))) {
            game.admin = address(bytes20(bytes(_value)));
        }
    }

    function setWord(string memory _word) public onlyOwner {
        _setGameProperty("word", _word);
    }

    function setClue(string memory _clue) public onlyOwner {
        _setGameProperty("clue", _clue);
    }

    function setAdmin(string memory _admin) public onlyOwner {
        _setGameProperty("admin", _admin);
    }

    function getWord() public view returns (string memory) {
        games[msg.sender].word;
    }

    function reset() public onlyOwner {
        games[msg.sender].word = "";
    }

    function getClue() public view returns (string memory) {
        games[msg.sender].clue;
    }

    function getAdmin() public view returns (string memory) {
        games[msg.sender].admin;
    }

    function getWinner() public view returns (address) {
        games[msg.sender].winner;
    }
}
