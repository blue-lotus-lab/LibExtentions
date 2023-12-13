// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.7.0 <0.9.0;

/**
 * Secure ERC20 Transfer Library
 * 
 * disclaimer:
 * ! this is based on gnosis safe multisig wallet.
 * ! We are just translate that from contract to library for easy reuse purposes
 * ! read all comments in code
 *
 * all solidity version 0.8.x compatible
 * test: solidity 0.8.22
 * openzeppelin v5 compatible
 * use this with your own risk, so always doing the security audit for production.
 *
 * Snippets created by: https://lotuschain.org {LibExtentions}
*/

/// @title SecuredTokenTransferLib - Secure token transfer library
/// @author Richard Meissner - <richard@gnosis.pm>
/// @dev The library edition by mosi-sol@github - <mosi@lotuschain.org>
library SecuredTokenTransferLib {
    /// @dev Transfers a token and returns if it was a success
    /// @param token Token that should be transferred
    /// @param receiver Receiver to whom the token should be transferred
    /// @param amount The amount of tokens that should be transferred
    function transferToken(
        address token,
        address receiver,
        uint256 amount
    ) internal returns (bool transferred) {
        // 0xa9059cbb - keccack("transfer(address,uint256)")
        bytes memory data = abi.encodeWithSelector(0xa9059cbb, receiver, amount);
        // solhint-disable-next-line no-inline-assembly
        assembly {
            // We write the return value to scratch space.
            // See https://docs.soliditylang.org/en/v0.7.6/internals/layout_in_memory.html#layout-in-memory
            let success := call(sub(gas(), 10000), token, 0, add(data, 0x20), mload(data), 0, 0x20)
            switch returndatasize()
                case 0 {
                    transferred := success
                }
                case 0x20 {
                    transferred := iszero(or(iszero(success), iszero(mload(0))))
                }
                default {
                    transferred := 0
                }
        }
    }
}

// =========================================
// === how to use the safe erc20 library ===
// =========================================

// import "./SecuredTokenTransferLib.sol";

/// @title ContractUsingSecuredTokenTransferLib - Example contract using SecuredTokenTransferLib
/// @dev The example by mosi-sol@github - <mosi@lotuschain.org>
/// @dev security: when use it as a library, use reentrancy/role check on the function in contract
contract ContractUsingSecuredTokenTransferLib {
    using SecuredTokenTransferLib for address;

    // Example 1 function using the library
    function transferTokens(
        address token,
        address receiver,
        uint256 amount
    ) external returns (bool transferred) {
        // reentrancy guard here
        // Use the library function
        transferred = token.transferToken(receiver, amount);
    }

    // Example 2 function using the library
    function checkTransfer(
        address token,
        address receiver,
        uint256 amount
    ) external {
        // reentrancy guard here
        // Use the library function
        require(token.transferToken(receiver, amount));
    }

    // Example 3 function using the library
    function checkTransferPass1(
        address token,
        address receiver,
        uint256 amount
    ) external {
        // reentrancy guard here
        // Use the library function
        if(token.transferToken(receiver, amount) == false) {
            revert("Transaction failed");
        }
        // else something, because transaction success
    }

    // Example 4 function using the library
    function checkTransferPass2(
        address token,
        address receiver,
        uint256 amount
    ) external {
        // reentrancy guard here
        // Use the library function
        token.transferToken(receiver, amount) == false ? 
        helper("failed") : 
        helper("success");
    }

    // Example helper test
    event Test(string);
    function helper(string memory message) public {
        emit Test(message);
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
