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

    function splitSignature(bytes memory sig) internal pure returns(uint8 v, bytes32 r, bytes32 s){
        require(sig.length == 65, "Invalid signature length");

        assembly {
            // sig - pointer of sig length
            // sig + 32 - first 32 bytes of sig, after sig length
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final (1) byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // implicit return 
    }
}
