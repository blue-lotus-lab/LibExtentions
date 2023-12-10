// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * WrapToken, Native token
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
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract WETH is ERC20, ReentrancyGuard, Ownable {
    using SafeMath for uint256;
    using Address for address;
    using SafeERC20 for IERC20;

    // Event to log wrapping and unwrapping of native tokens
    event Wrap(address indexed from, uint256 amount);
    event Unwrap(address indexed from, uint256 amount);

    constructor() ERC20("Wrapped Ether", "WETH") Ownable(msg.sender) {}

    modifier nonZeroAddress(address _addr) {
        require(_addr != address(0), "Zero address not allowed");
        _;
    }

    // Wrap native tokens (ETH) to mint WETH
    function wrap() external payable nonReentrant {
        uint256 amount = msg.value;
        require(amount > 0, "Amount must be greater than 0");

        _mint(msg.sender, amount);
        emit Wrap(msg.sender, amount);
    }

    // Unwrap WETH to get back native tokens (ETH)
    function unwrap(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient WETH balance");

        _burn(msg.sender, amount);
        Address.sendValue(payable(msg.sender), amount);
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

    // Fallback function to receive native tokens (ETH)
    receive() external payable {
        // Allow receiving Ether directly to the contract
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
