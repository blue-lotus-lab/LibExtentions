# ZK-morphology Smart Contract Documentation
**Best point to learning is practice. To the point, learn how to playing with code.**

## Overview

The ZKNft smart contract is an Ethereum-based ERC-721 token contract that provides a mechanism for users to claim and mint unique tokens using a zero-knowledge proof. It consists of two main contracts: `SimpleVerifier` and `ZKNft`. The `SimpleVerifier` contract handles zero-knowledge proof verification, while the `ZKNft` contract inherits from ERC-721 and integrates the `SimpleVerifier` for secure token claiming.

## Contracts
> deploy assist: [here](./ZK-Morph.md#usage)

### 1. SimpleVerifier
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleVerifier {
    // Simple "secret" value
    bytes32 private secret;

    // Mapping to track claimed tokens by user
    mapping(address => bool) private claimedTokens;

    // Event emitted on successful verification and token claim
    event ProofVerified(address indexed prover, bool success);

    // Constructor to set the initial secret value
    constructor(bytes32 _secret) {
        secret = _secret;
    }

    // Function to generate a proof
    function generateProof(bytes memory data) internal pure returns (bytes32) {
        return sha256(data);
    }

    // Function to verify a proof
    function verifyProof(bytes memory data, bytes32 proof) external view returns (bool) {
        bytes32 hashedData = sha256(data);
        bool success = (hashedData == secret) && (hashedData == proof);

        // Emit an event to log the result of the verification
        // emit ProofVerified(msg.sender, success);

        return success;
    }

    // Function to check if a user has already claimed a token
    function hasClaimedToken(address user) external view returns (bool) {
        return claimedTokens[user];
    }

    // Function to mark a token as claimed by a user
    function markTokenAsClaimed(address user) public {
        claimedTokens[user] = true;
    }
}
```

#### 1.1 Functions

- **`constructor(bytes32 _secret)`**: Initializes the `SimpleVerifier` contract with a secret value, which is used as part of the zero-knowledge proof verification process.

- **`generateProof(bytes memory data) internal pure returns (bytes32)`**: Internal function to generate a proof by hashing the provided data using SHA-256.

- **`verifyProof(bytes memory data, bytes32 proof) external view returns (bool)`**: External function allowing users to verify a zero-knowledge proof. It compares the hashed data and the provided proof with the stored secret value, emitting a `ProofVerified` event on success.

- **`hasClaimedToken(address user) external view returns (bool)`**: Checks whether a user has already claimed a token.

- **`markTokenAsClaimed(address user) public`**: Marks a token as claimed by a user, preventing them from claiming additional tokens.

#### 1.2 Events

- **`ProofVerified(address indexed prover, bool success)`**: Emitted when a zero-knowledge proof is successfully verified. The event logs the address of the entity attempting the proof verification and the success status.

### 2. ZKNft
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./SimpleVerifier.sol";

contract ZKproofNFT is ERC721Enumerable, SimpleVerifier {
    SimpleVerifier private verifier;

    constructor(bytes32 _secret) ERC721("ZKtoken", "ZKNFT") SimpleVerifier(_secret) {
        verifier = SimpleVerifier(this);
    }

    // Claim/Mint function with zero-knowledge proof verification
    function claim(bytes memory data, bytes32 proof) external {
        require(!verifier.hasClaimedToken(msg.sender), "Token already claimed");
        require(verifier.verifyProof(data, proof), "Invalid proof");

        // Mark the token as claimed by the user
        verifier.markTokenAsClaimed(msg.sender);

        // Mint a new token
        uint256 tokenId = totalSupply() + 1;
        _safeMint(msg.sender, tokenId);
    }
}
```

Inherits from ERC-721 and utilizes `SimpleVerifier` for proof verification.

#### 2.1 Functions

- **`constructor(bytes32 _secret)`**: Initializes the `ZKNft` contract with a secret value during deployment. Additionally, it mints a predefined number of initial tokens for testing purposes.

- **`claim(bytes memory data, bytes32 proof) external`**: Allows users to claim and mint tokens by providing a zero-knowledge proof. Before minting, it checks if the user has already claimed a token and if the proof is valid.

## Usage

1. **Deploying the Contracts:**

   Deploy the `ZKNft` contract by providing a secret value for the zero-knowledge proof verification process.

   ✍️ Using example secret & public key:
   - **bytes**:   `0x0796c429dc324fa355cb5993bd527a4365fb66d4bf5b1d39fb847d28898efab9`
   - **bytes32**: `0x9e130d492c15bbba04c936280488681404803846f779549b383dfd936f80e03c`

3. **Minting Tokens:**

   Users can mint tokens by calling the `claim` function, providing valid proof data. The contract ensures that each user can only claim one token.

4. **Zero-Knowledge Proof Verification:**

   The zero-knowledge proof is verified using the `verifyProof` function from the `SimpleVerifier` contract, which compares the provided proof with the stored secret value.

5. **Checking Claimed Tokens:**

   The `hasClaimedToken` function in the `SimpleVerifier` contract allows checking if a user has already claimed a token.

## Security Considerations

- Ensure that the secret value used for proof verification is kept secure. Any compromise of this value could lead to unauthorized token claims.

- Validate zero-knowledge proofs thoroughly to prevent unauthorized token claims. Users should not be able to successfully claim tokens without providing a valid proof.

## Events

- The `ProofVerified` event is emitted on successful proof verification, providing transparency into the success or failure of zero-knowledge proof attempts.

## License

This smart contract is licensed under the MIT License, granting users the freedom to use, modify, and distribute the code.