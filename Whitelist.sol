// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Whitelist {
  address[] public whitelisted;
  mapping(address => bool) public whitelistedMap;

  event Authorized(address _address);
  event EthReceived(address _from, uint256 _value);



  receive() external payable {
    emit EthReceived(msg.sender, msg.value);
  }

  fallback() external payable {
    emit EthReceived(msg.sender, msg.value);
  }

  function checkWhitelist() private view returns(bool) {
    if (whitelistedMap[msg.sender]) {
      return true;
    }
    return false;
  }

  function authorize(address _address) public {
    require(checkWhitelist(), "You are not authorized");
    whitelistedMap[_address] = true;
    emit Authorized(_address);
  }
}