// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Whitelist {
  address[] public whitelisted;
  mapping(address => bool) public whitelistedMap;

  event Authorized(address _address);
  event EthReceived(address _from, uint256 _value);

  constructor() {
    whitelistedMap[msg.sender] = true;
  }

  receive() external payable {
    emit EthReceived(msg.sender, msg.value);
  }

  fallback() external payable {
    emit EthReceived(msg.sender, msg.value);
  }
  // utiliser un modifier à la place de la fonction checkWhitelist
  // function checkWhitelist() private view returns(bool) {
  //   if (whitelistedMap[msg.sender]) {
  //     return true;
  //   }
  //   return false;
  // }
  modifier checkWhitelist() {
    require(whitelistedMap[msg.sender], "You are not authorized");
    _;
  }

  function authorize(address _address) public checkWhitelist {
    whitelistedMap[_address] = true;
    emit Authorized(_address);
  }

  
}