// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Interface WrapToken, Native token, ERC20 token
 * 
 * disclaimer
 *
 * all solidity version 0.8.x compatible
 * test: solidity 0.8.22
 *
 * Used in: https://github.com/blue-lotus-lab/LibExtentions/blob/main/contracts%40v3/snippets/Wrap/WrapETH.sol
 * and: https://github.com/blue-lotus-lab/LibExtentions/blob/main/contracts%40v3/snippets/Wrap/WrapErc20.sol
 *
 * Snippets created by: https://lotuschain.org {LibExtentions}
*/

interface IWETH {
    // Event to log wrapping and unwrapping of native tokens
    event Wrap(address indexed from, uint256 amount);
    event Unwrap(address indexed from, uint256 amount);

    // Wrap native tokens (ETH) to mint WETH
    function wrap() external payable;

    // Unwrap WETH to get back native tokens (ETH)
    function unwrap(uint256 amount) external;
}

// ------------------------------------------------------------

interface IWrap {
    // Event to log wrapping and unwrapping of ERC-20 tokens
    event Wrap(address indexed from, uint256 amount);
    event Unwrap(address indexed from, uint256 amount);

    // Wrap ERC-20 tokens to mint WETHT
    function wrap(uint256 amount) external;

    // Unwrap WETHT to get back ERC-20 tokens
    function unwrap(uint256 amount) external;
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
