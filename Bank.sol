// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.2;

 contract Bank {
    uint public balance;

    mapping(address => uint) public balances;

    function deposit(uint amount) public payable {
      balances[msg.sender] += amount;
    }

    function transfer(address _to, uint amount) public payable {
      require(amount > 0, "Amount must be greater than 0");
      require(_to != address(0), "You can't burn yours tokens");
      require(balances[msg.sender] >= amount, "Insufficient balance");
      balances[msg.sender] -= amount;
      balances[_to] += amount;
    }

    function balanceOf(address user) public view returns (uint) {
      return balances[user];
    }

    function getBalance() public view returns (uint) {
      return address(this).balance;
    }
 }