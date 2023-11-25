// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *    using BitwiseLibrary for uint256;
 *       
 *    function performBitwiseOperations(uint256 a, uint256 b, uint256 mask) external pure returns (uint256) {
        uint256 result;
        // Bitwise AND
        result = a.bitwiseAnd(b);
        // Bitwise OR
        result = result.bitwiseOr(a);
        // Bitwise XOR
        result = result.bitwiseXor(b);
        // Bitwise NOT
        result = result.bitwiseNot();
        // Bitwise mask
        result = result.bitwiseMask(mask);
        return result;
      }
 *  ```
 * then implementing requirment functions.
 *
 * this library use for uint256, inspire from it!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library BitwiseLibrary {
    // Bitwise AND operation
    function bitwiseAnd(uint256 a, uint256 b) internal pure returns (uint256) {
        return a & b;
    }

    // Bitwise OR operation
    function bitwiseOr(uint256 a, uint256 b) internal pure returns (uint256) {
        return a | b;
    }

    // Bitwise XOR operation
    function bitwiseXor(uint256 a, uint256 b) internal pure returns (uint256) {
        return a ^ b;
    }

    // Bitwise NOT operation
    function bitwiseNot(uint256 a) internal pure returns (uint256) {
        return ~a;
    }

    // Bitwise mask operation
    function bitwiseMask(uint256 a, uint256 mask) internal pure returns (uint256) {
        return a & mask;
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
