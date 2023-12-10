// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * WrapToken, Non native token
 * 
 * disclaimer
 *
 * all solidity version 0.8.x compatible
 * test: solidity 0.8.22
 * openzeppelin v5 compatible
 * use this with your own risk, so always doing the security audit for production.
 *
 * Snippets created by: https://lotuschain.org {LibExtentions}
*/

import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract WToken is ERC20, ReentrancyGuard, Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public underlyingToken;

    // Event to log wrapping and unwrapping of ERC-20 tokens
    event Wrap(address indexed from, uint256 amount);
    event Unwrap(address indexed from, uint256 amount);

    constructor(address _underlyingToken) ERC20("Wrapped ERC-20 Token", "WETHT") Ownable(msg.sender) {
        underlyingToken = IERC20(_underlyingToken);
    }

    modifier nonZeroAddress(address _addr) {
        require(_addr != address(0), "Zero address not allowed");
        _;
    }

    // Wrap ERC-20 tokens to mint WETHT
    function wrap(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");

        // Transfer ERC-20 tokens from the caller to this contract
        underlyingToken.safeTransferFrom(msg.sender, address(this), amount);

        // Mint equivalent WETHT tokens to the caller
        _mint(msg.sender, amount);

        emit Wrap(msg.sender, amount);
    }

    // Unwrap WETHT to get back ERC-20 tokens
    function unwrap(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient WETHT balance");

        // Burn WETHT tokens from the caller
        _burn(msg.sender, amount);

        // Transfer equivalent ERC-20 tokens to the caller
        underlyingToken.safeTransfer(msg.sender, amount);

        emit Unwrap(msg.sender, amount);
    }

    // Owner-only function to recover accidentally sent ERC-20 tokens
    function recoverTokens(address tokenAddress, uint256 tokenAmount)
        external
        onlyOwner
        nonZeroAddress(tokenAddress)
    {
        IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
    }
}

/* ----------------------------------------------------------------------------------
[
    { 
        "creator": "lotuschain-lab",
        "web3-home": "https://lotuschain.org",
        "ALT-id": "@ALT"
    }
]
---------------------------------------------------------------------------------- */
