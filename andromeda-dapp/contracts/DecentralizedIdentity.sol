// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract DecentralizedIdentity is Ownable {
    using ECDSA for bytes32;

    struct Identity {
        address owner;
        string did;
        bool verified;
    }

    mapping(address => Identity) public identities;
    mapping(bytes32 => bool) public verifiedSignatures;

    event IdentityRegistered(address indexed user, string did);
    event IdentityVerified(address indexed user);

    function registerIdentity(string memory _did) public {
        require(bytes(identities[msg.sender].did).length == 0, "Identity already registered");
        identities[msg.sender] = Identity(msg.sender, _did, false);
        emit IdentityRegistered(msg.sender, _did);
    }

    function verifyIdentity(address _user, bytes32 messageHash, bytes memory signature) public onlyOwner {
        require(identities[_user].owner != address(0), "Identity not found");
        require(!identities[_user].verified, "Identity already verified");
        require(!verifiedSignatures[messageHash], "Signature already used");
        
        address recoveredSigner = messageHash.toEthSignedMessageHash().recover(signature);
        require(recoveredSigner == _user, "Invalid signature");

        identities[_user].verified = true;
        verifiedSignatures[messageHash] = true;
        emit IdentityVerified(_user);
    }

    function getIdentity(address _user) public view returns (string memory did, bool verified) {
        require(identities[_user].owner != address(0), "Identity not found");
        return (identities[_user].did, identities[_user].verified);
    }
}