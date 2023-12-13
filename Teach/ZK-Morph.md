# ZK-morphology Smart Contract Documentation
**The most effective way to acquire knowledge is through hands-on experience. Cut straight to the chase and immerse yourself in the art of coding.**

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

This smart contract is licensed under the MIT + GNU-GPL3 Dual Licenses, granting users the freedom to use, modify, and distribute the code.

## Liberation
Which solution shines brighter—this one or ECDS alternatives such as merkle-proof or signing messages? 
- The only thing that truly counts is the scope of the use case!

## Disclaimer
This is just a tutorial example, not a product code. Just inspire from this.

## Simple Usecase
Simple ICO with using ZK-Proof.
- using `nonce` for safety 

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ZK example for verify
contract ZKVerifier {
    mapping(address => bytes32) private userSecrets;
    mapping(address => uint256) public nonces;

    event ProofVerified(address indexed prover, bool success);

    function setSecret(bytes32 _secret) external {
        require(userSecrets[msg.sender] == bytes32(0), "Secret already set");
        userSecrets[msg.sender] = _secret;
    }

    function generateProof() internal view returns (bytes32) {
        require(userSecrets[msg.sender] != bytes32(0), "User secret not set");
        // todo: need a check for nonce, nonce must be unique for each user wallet
        uint256 nonce = _nonce(); // nonces[msg.sender]++;
        return sha256(abi.encodePacked(nonce, userSecrets[msg.sender]));
    }

    function verifyProof(uint256 nonce, bytes32 proof) external returns (bool) {
        require(nonce < nonces[msg.sender], "Invalid nonce");
        bytes32 hashedData = sha256(abi.encodePacked(nonce, userSecrets[msg.sender]));
        bool success = hashedData == proof;

        emit ProofVerified(msg.sender, success);

        return success;
    }

    function _nonce() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp, block.number)));
    }
}

// Simple ICO, used zk-proof
import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract ICO is ZKVerifier, ERC20, Ownable {
    using SafeERC20 for IERC20;
    using Address for address;

    ZKVerifier private verifier;

    uint256 public constant ICO_TOKEN_PRICE = 1 ether;
    uint256 public constant MAX_TOKENS_FOR_SALE = 1000000 * (10**18);
    uint256 public tokensSold;

    event TokensPurchased(address indexed buyer, uint256 amount, uint256 totalTokensSold);

    constructor(address initialOwner) ERC20("IcoToken", "ICO") Ownable(initialOwner) {
        verifier = ZKVerifier(this);
        // _mint(msg.sender, MAX_TOKENS_FOR_SALE);
        _mint(address(this), MAX_TOKENS_FOR_SALE);
    }
    
    function buyTokens(uint256 nonce, bytes32 proof) external payable {
        require(verifier.verifyProof(nonce, proof), "Invalid proof");

        uint256 tokensToBuy = msg.value / ICO_TOKEN_PRICE;

        require(tokensToBuy > 0 && tokensSold + tokensToBuy <= MAX_TOKENS_FOR_SALE, "Not enough tokens available for sale");

        // Update state before interacting with external contracts
        tokensSold += tokensToBuy;

        // Emit event for the state change
        emit TokensPurchased(msg.sender, tokensToBuy, tokensSold);

        // Transfer tokens after state is updated
        IERC20(address(this)).safeTransferFrom(address(this), msg.sender, tokensToBuy);
        // if tokens minted on owner wallet, use next commented code line
        // todo: next line is vulnerable, must to secure it
        // _transfer(owner(), msg.sender, tokensToBuy);
    }

    function withdrawEther() external onlyOwner {
        Address.sendValue(payable(owner()), address(this).balance);
    }
}
```
