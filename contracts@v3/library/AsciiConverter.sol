// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *   using AsciiConverter for string;
 *   function convertAndUse(string memory _input) external pure returns (uint[] memory) {
 *       uint[] memory convertedNumbers = _input.convertToNumbers();
 *       // Perform any further operations with the converted numbers if needed
 *       return convertedNumbers;
 *   }
 *  ```
 * then implementing requirment functions.
 *
 * this is work on "string, int256, bool". you can inspire from it!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library AsciiConverter {
    function convertToNumbers(string memory _input) internal pure returns (uint[] memory) {
        bytes memory inputBytes = bytes(_input);
        uint tmp = inputBytes.length;
        uint[] memory numbers = new uint[](tmp);

        for (uint i = 0; i < tmp; i++) {
            numbers[i] = uint8(inputBytes[i]);
        }

        return numbers;
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
