// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "./Token.sol";

contract Crowdsale {
  uint public rate = 200;
  Token public token;

  constructor() ERC20("Alyra", "Cal") {
    token = new Token(initialSupply);
  }

  receive() external payable {
    require(msg.value >= 0.1 ether, "you can't send less than 0.1 ether");
    distribute(msg.value);
  }

  function distribute(uint amount) internal {
    uint256 tokensToSent = amount * rate;
    token.transfer(msg.sender, tokensToSent);
  }

}