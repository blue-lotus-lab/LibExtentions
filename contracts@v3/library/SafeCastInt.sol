// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * SAFECAST: INT EDITION
 * @dev How to use:
 * first import library, then
 *  ```
 *   using SafeCastLibrary for int256;
 *   fn(int256 value) external pure returns (int8, int16, int32) {
 *       int8 valueint8 = int8(SafeCastLibrary.toIntN(value, 8));
 *       int16 valueint16 = int16(SafeCastLibrary.toIntN(value, 16));
 *       int32 valueint32 = int32(SafeCastLibrary.toIntN(value, 32));
 *   }
 *  ```
 * then implementing requirment functions.
 *
 * this is work on "all int's". 
 * you can inspire from it to build creative tools!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library SafeCastLibrary {

    error ToHighestOfRange();

    function toIntN(int256 value, uint8 bits) internal pure returns (int256) {
        require(bits > 0 && bits <= 256, "Invalid number of bits");
        int256 minValue = -(int256(1) << (bits - 1));
        int256 maxValue = (int256(1) << (bits - 1)) - 1;

        if (value < minValue || value > maxValue) {
            revert ToHighestOfRange();
        }

        int256 result;
        assembly {
            // Check if value fits within the specified range
            if slt(value, minValue) {
                revert(0, 0)
            }
            if sgt(value, maxValue) {
                revert(0, 0)
            }
            result := value
        }
        return result;
    }

    // Example usage:
    // int8: toIntN(value, 8)
    // int16: toIntN(value, 16)
    // int32: toIntN(value, 32)
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
