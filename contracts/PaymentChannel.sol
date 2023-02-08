// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract PaymentChannel {
    address public sender;
    address public recipient;
    uint256 public expiration;
    bool public transfering;

    constructor(address _recipient, uint256 _duration) payable {
        sender = msg.sender;
        recipient = _recipient;
        expiration = block.timestamp + _duration;
    }

    function close(uint256 amount, bytes memory sig) public {
        require(msg.sender == recipient, "Only recipient");
        require(isValidSignature(amount, sig), "Invalid signature");
        require(!transfering, "Already transfering funds");

        transfering = true;

        (bool success,) = payable(recipient).call{value: amount}("");
        
        transfering = false;

        require(success, "Transfer failed");
        selfdestruct(payable(sender));
    }

    function extend(uint256 newExpiration) public {
        require(msg.sender == sender, "Only for sender");
        require(newExpiration > expiration, "Must be after current expiration");

        expiration = newExpiration;
    }

    function isValidSignature(uint256 amount, bytes memory sig) internal view returns(bool){
        bytes32 message = getEthSignedMessageHash(keccak256(abi.encodePacked(this, amount)));

        // Check that the signature is from the payment sender.
        return recoverSigner(message, sig) == sender;
    }

    function getEthSignedMessageHash(bytes32 message) internal pure returns(bytes32){
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", message));
    }

    function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address){
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
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
