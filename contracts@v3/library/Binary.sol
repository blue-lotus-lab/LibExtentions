// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *   using BinaryConverter for *;    
 *   function convertToBinary(uint256 value) external pure returns (string memory) {
 *       return value.toBinaryString();
 *   }    
 *   function convertToUint(string memory binaryString) external pure returns (uint256) {
 *       return binaryString.toUintFromBinaryString();
 *   }
 *  ```
 * then implementing requirment functions.
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library BinaryConverter {
    function toBinaryString(uint256 _number) internal pure returns (string memory) {
        if (_number == 0) {
            return "0";
        }

        uint256 temp = _number;
        uint256 length;
        
        while (temp != 0) {
            length++;
            temp /= 2;
        }

        bytes memory result = new bytes(length);

        for (uint256 i = 0; i < length; i++) {
            // result[length - i - 1] = bytes1(((_number >> i) & 1) + 0x30);
            result[length - i - 1] = bytes1(uint8(((_number >> i) & 1) + 0x30));
        }

        return string(result);
    }

    function toUintFromBinaryString(string memory _binaryString) internal pure returns (uint256) {
        bytes memory binaryBytes = bytes(_binaryString);
        uint256 result = 0;

        for (uint256 i = 0; i < binaryBytes.length; i++) {
            require(binaryBytes[i] == '0' || binaryBytes[i] == '1', "BinaryConverter: Invalid binary string");

            if (binaryBytes[i] == '1') {
                result = result * 2 + 1;
            } else {
                result = result * 2;
            }
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
