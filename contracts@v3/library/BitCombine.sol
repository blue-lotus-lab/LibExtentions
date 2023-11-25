// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *    using BitwiseCombinationLibrary for BitwiseCombinationLibrary.BitwiseData;
 *    BitwiseCombinationLibrary.BitwiseData private data;
 *    function combineValues(uint a, uint b) public { data.combineValues(a, b); }    
 *    function extractValues() public view returns (uint a, uint b) { return data.extractValues(); }
 *  ```
 * then implementing requirment functions.
 *
 * this is work on uint256. you can inspire from it!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library BitwiseCombinationLibrary {
    struct BitwiseData {
        uint combinedValue;
    }

    function combineValues(BitwiseData storage data, uint a, uint b) internal {
        data.combinedValue = (a & 0xFF) | (b << 8);
    }

    function extractValues(BitwiseData storage data) internal view returns (uint a, uint b) {
        a = data.combinedValue & 0xFF;
        b = (data.combinedValue >> 8) & 0xFF;
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
