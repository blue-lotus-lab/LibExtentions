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
 * this is work for "UTF8". 
 * you can inspire from it!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

// REGX UTF8 Support
library CharacterSets {
    function containsLowercase(string memory _str) internal pure returns (bool) {
        bytes memory strBytes = bytes(_str);
        for (uint i = 0; i < strBytes.length; i++) {
            if (isLowercaseUTF8Char(strBytes, i)) {
                return true;
            }
        }
        return false;
    }

    function containsUppercase(string memory _str) internal pure returns (bool) {
        bytes memory strBytes = bytes(_str);
        for (uint i = 0; i < strBytes.length; i++) {
            if (isUppercaseUTF8Char(strBytes, i)) {
                return true;
            }
        }
        return false;
    }

    function containsNumbers(string memory _str) internal pure returns (bool) {
        bytes memory strBytes = bytes(_str);
        for (uint i = 0; i < strBytes.length; i++) {
            if (isNumberUTF8Char(strBytes, i)) {
                return true;
            }
        }
        return false;
    }

    function containsSymbols(string memory _str) internal pure returns (bool) {
        bytes memory strBytes = bytes(_str);
        for (uint i = 0; i < strBytes.length; i++) {
            if (isSymbolUTF8Char(strBytes, i)) {
                return true;
            }
        }
        return false;
    }
    function isLowercaseUTF8Char(bytes memory strBytes, uint index) internal pure returns (bool) {
        return (strBytes[index] >= 0x61 && strBytes[index] <= 0x7A); // Check if it's a UTF-8 lowercase character
    }

    function isUppercaseUTF8Char(bytes memory strBytes, uint index) internal pure returns (bool) {
        return (strBytes[index] >= 0x41 && strBytes[index] <= 0x5A); // Check if it's a UTF-8 uppercase character
    }

    function isNumberUTF8Char(bytes memory strBytes, uint index) internal pure returns (bool) {
        return (strBytes[index] >= 0x30 && strBytes[index] <= 0x39); // Check if it's a UTF-8 numeric character
    }

    function isSymbolUTF8Char(bytes memory strBytes, uint index) internal pure returns (bool) {
        // Check if it's a UTF-8 character that is not alphanumeric
        return !(isLowercaseUTF8Char(strBytes, index) || isUppercaseUTF8Char(strBytes, index) || isNumberUTF8Char(strBytes, index));
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
