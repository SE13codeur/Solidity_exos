// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Token.sol";

contract Savings is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(uint256 => uint256) deposits;
    uint256 depositId;
    uint256 time;

    function deposit() external payable onlyOwner {
        require(msg.value > 0, "Not enough funds provided");
        depositId++;
        if(time == 0) {
            time = block.timestamp + 120 days;
        }
    }

    function withdraw() external onlyOwner {
        require(block.timestamp >= time, "Wait 3 months");
        (bool sent,) = msg.sender.call{value: address(this).balance}("");
        require(sent, "An error occured");
    }
    
}