// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *   using SafeCastLibrary for uint256;
 *   fn(uint256 value) external pure returns (uint8, uint16, uint32) {
 *       uint8 valueUint8 = uint8(SafeCastLibrary.toUintN(value, 8));
 *       uint16 valueUint16 = uint16(SafeCastLibrary.toUintN(value, 16));
 *       uint32 valueUint32 = uint32(SafeCastLibrary.toUintN(value, 32));
 *   }
 *  ```
 * then implementing requirment functions.
 *
 * this is work on "all uint's". 
 * you can inspire from it to build creative tools!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library SafeCastLibrary {

    error ToHighestOfRange();

    function toUintN(uint256 value, uint8 bits) internal pure returns (uint256) {
        require(bits > 0 && bits <= 256, "Invalid number of bits");
        uint256 maxValue = (1 << bits) - 1;

        if (value > maxValue) revert ToHighestOfRange();

        uint256 result;
        assembly {
            // Check if value fits within the specified range
            if gt(value, maxValue) {
                revert(0, 0)
            }
            result := value
        }
        return result;
    }

    // Example usage:
    // uint8: toUintN(value, 8)
    // uint16: toUintN(value, 16)
    // uint32: toUintN(value, 32)
    // ... and so on
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
