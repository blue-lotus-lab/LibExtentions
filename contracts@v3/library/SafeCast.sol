// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *   using SafeCastLibrary for int256;
 *   using SafeCastLibrary for uint256;
 *   function testSafeCasts() external pure returns (uint, int) {
 *       int256 intValue = 14;
 *       uint256 uintValue = 25;
 *       int256 castedInt = intValue.toIntN(8);
 *       uint256 castedUInt = uintValue.toUIntN(8);
 *       // Perform assertions or other checks as needed
 *       // For example, assert(castedInt == 14);
 *       // For example, assert(castedUInt == 25);
 *       return (castedUInt, castedInt);
 *   }
 *  ```
 * then implementing requirment functions.
 *
 * this is work on "int cast and uint cast in same lib". 
 * you can inspire from it!
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

    function toUIntN(uint256 value, uint8 bits) internal pure returns (uint256) {
        require(bits > 0 && bits <= 256, "Invalid number of bits");
        uint256 maxValue = (uint256(1) << bits) - 1;

        if (value > maxValue) {
            revert ToHighestOfRange();
        }

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
