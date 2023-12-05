// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.2;

import "./Token.sol";

 contract Admin is Ownable {
    
    mapping(address => bool) private whitelistedMap;
    mapping(address => bool) private blacklistedMap;

    event Authorized(address _user);
    event Banned(address _user);

    constructor(address _admin) Ownable(_admin) {
      _admin = msg.sender;
    }

    function whitelist(address _user) public onlyOwner {
      require(!whitelistedMap[_user], "Already whitelisted");
      require(!blacklistedMap[_user], "Already blacklisted");
      whitelistedMap[_user] = true;
      emit Authorized(_user);
    }

    function unauthorize(address _user) public onlyOwner {
      require(whitelistedMap[_user], "Not whitelisted");
      require(!blacklistedMap[_user], "Already blacklisted");
      // whitelistedMap[_user] = false;
      blacklistedMap[_user] = true;
      emit Banned(_user);
      // blacklistedMap[_user] = true;
    }

    function isWhitelisted(address _user) public view onlyOwner returns (bool) {
      return whitelistedMap[_user];
    }

    function isBlacklisted(address _user) public view onlyOwner returns (bool) {
      return blacklistedMap[_user];
    }



}