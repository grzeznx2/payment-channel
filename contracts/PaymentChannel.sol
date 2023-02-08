// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract PaymentChannel {
    address public sender;
    address public recipient;
    uint256 public expiration;

    constructor(address _recipient, uint256 _duration) payable {
        sender = msg.sender;
        recipient = _recipient;
        expiration = block.timestamp + _duration;
    }
}
