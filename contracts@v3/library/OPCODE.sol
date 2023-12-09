// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *   examples of "how to use" in buttom of this file
 *  ```
 * 
 * ! not limitation of use this convertor statement !
 *
 * you can inspire from it!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

// opcode max length is 255 (uint8 max) = 0xff
library OpcodeUtils {
    function opcodeToNumber(bytes memory opcode) internal pure returns (uint256) {
        require(opcode.length == 1, "Invalid opcode length");
        bytes1 opcodeByte = opcode[0];
        return uint256(uint8(opcodeByte));
    }

    function numberToOpcode(uint256 number) internal pure returns (bytes memory) {
        require(number <= 255, "Invalid opcode number");
        return abi.encodePacked(uint8(number));
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

// ======================================================
// ================ LIST OF EXAMPLES ====================
// ======================================================
/*
// import "./OpcodeUtils.sol";

contract TestContract {
    using OpcodeUtils for bytes;
    
    function convertOpcodeToNumber(bytes memory opcode) public pure returns (uint256) {
        return opcode.opcodeToNumber();
    }
    
    function convertNumberToOpcode(uint256 number) public pure returns (bytes memory) {
        return OpcodeUtils.numberToOpcode(number);
    }
}
*/
