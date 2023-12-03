// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Whitelist {
  address[] public whitelisted;
  mapping(address => bool) public whitelistedMap;

  event Authorized(address _address);
}