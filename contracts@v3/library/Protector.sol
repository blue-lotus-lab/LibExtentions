// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then for example
 *  ```
 *    function fx() public view returns (bool) {
 *        return LibProtector._protected();
 *    }
 *  
 *    // using for reentrancy guard
 *    function withdraw() public payable {
 *        require(LibProtector._protected());
 *        // the code here
 *    }
 *  ```
 * then implementing requirment functions.
 * security: using checks in functions to ensure about the user was added or removed before. 
 * in this case can to using "onlyOwner" or user role.
 *
 * ⚠️ spoiler alert: this method can to bypass, but usefull in many cases. Lts be creative!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library LibProtector {
    // ---------------------------------------------------------------
    // • for library usecase
    // example use:
    // require(LibProtector._protected());
    // --------------------------------------------------------------- 
    function _protected() internal view returns (bool) {
        if(isContract(msg.sender)) {
            return false;
        }
        return true;
    }

    // •——• utils
    function isContract(address account) internal view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
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
