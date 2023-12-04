// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "./Token.sol";

contract Guess is Ownable {

  string public word;
  string public clue;
  string public admin; 

  constructor() Ownable(msg.sender) {}

  mapping(address => bool) public played;

  function setWord(string memory _word) public onlyOwner {
    word = _word;
  }

  function setClue(string memory _clue) public onlyOwner {
    clue = _clue;
  }

  function setAdmin(string memory _admin) public onlyOwner {
    admin = _admin;
  }

  function getWord() public view returns (string memory) {
    return word;
  }

  function getClue() public view returns (string memory) {
    return clue;
  }

  function getAdmin() public view returns (string memory) {
    return admin;
  }

  function guess(string memory _word) public view returns (bool) {
    return _word == word;
  }

  function getWinner() public view returns (address) {
    return msg.sender;
  }

  function reset() public onlyOwner {
    word = "";
  }
}