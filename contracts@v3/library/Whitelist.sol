// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *    using WhitelistLibrary for WhitelistLibrary.Whitelist;
 *    WhitelistLibrary.Whitelist whitelist;
 *  ```
 * then implementing requirment functions.
 * security: using checks in functions to ensure about the user was added or removed before...
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library WhitelistLibrary {
    struct Whitelist {
        mapping(address => bool) members;
    }

    function addToWhitelists(Whitelist storage whitelist, address[] memory members) internal {
        for (uint256 i = 0; i < members.length; i++) {
            whitelist.members[members[i]] = true;
        }
    }

    function addToWhitelist(Whitelist storage whitelist, address members) internal {
        whitelist.members[members] = true;
    }

    function removeFromWhitelists(Whitelist storage whitelist, address[] memory members) internal {
        for (uint256 i = 0; i < members.length; i++) {
            whitelist.members[members[i]] = false;
        }
    }

    function removeFromWhitelist(Whitelist storage whitelist, address members) internal {
        whitelist.members[members] = false;
    }

    function isWhitelisted(Whitelist storage whitelist, address addr) internal view returns (bool) {
        return whitelist.members[addr];
    }

    // security checks in app
    /*
    function _addToWhitelist(address members) private {
        if(isWhitelisted(members) == false) 
            whitelist.members[members] = true;
    }

    function _removeFromWhitelist(address members) private {
        if(isWhitelisted(members) == true) 
            whitelist.members[members] = false;
    }
    */
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
