// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *   using CharacterSets for string;
 *   function checkCharacterSets(string memory _str) external pure returns (bool lowercase, bool uppercase, bool numbers, bool symbols) {
 *       lowercase = _str.containsLowercase();
 *       uppercase = _str.containsUppercase();
 *       numbers = _str.containsNumbers();
 *       symbols = _str.containsSymbols();
 *   }
 *  ```
 * then implementing requirment functions.
 *
 * this is work for "ASCII". 
 * you can inspire from it!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

// REGX ASCII Support
library CharacterSets {
    function containsLowercase(string memory _str) internal pure returns (bool) {
        bytes memory strBytes = bytes(_str);
        for (uint i = 0; i < strBytes.length; i++) {
            if ((strBytes[i] >= 0x61 && strBytes[i] <= 0x7A)) {
                return true;
            }
        }
        return false;
    }

    function containsUppercase(string memory _str) internal pure returns (bool) {
        bytes memory strBytes = bytes(_str);
        for (uint i = 0; i < strBytes.length; i++) {
            if ((strBytes[i] >= 0x41 && strBytes[i] <= 0x5A)) {
                return true;
            }
        }
        return false;
    }

    function containsNumbers(string memory _str) internal pure returns (bool) {
        bytes memory strBytes = bytes(_str);
        for (uint i = 0; i < strBytes.length; i++) {
            if ((strBytes[i] >= 0x30 && strBytes[i] <= 0x39)) {
                return true;
            }
        }
        return false;
    }

    function containsSymbols(string memory _str) internal pure returns (bool) {
        bytes memory strBytes = bytes(_str);
        for (uint i = 0; i < strBytes.length; i++) {
            if (!((strBytes[i] >= 0x30 && strBytes[i] <= 0x39) ||
                  (strBytes[i] >= 0x41 && strBytes[i] <= 0x5A) ||
                  (strBytes[i] >= 0x61 && strBytes[i] <= 0x7A))) {
                return true;
            }
        }
        return false;
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
