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
 * Security fix after the librart in buttom of codes.
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

// how to fix exploit:

/*
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library LibProtector {
    modifier nonReentrant() {
        require(!_locked, "Reentrant call detected!");
        _locked = true;
        _;
        _locked = false;
    }

    // Check if the caller is an externally-owned account (EOA)
    function isEOA() internal view returns (bool) {
        return msg.sender == tx.origin;
    }

    // Check if the caller is a contract
    function isContract() internal view returns (bool) {
        return !isEOA() && _getCodeSize(msg.sender) > 0;
    }

    function _getCodeSize(address account) internal view returns (uint) {
        bytes32 codehash;
        assembly {
            codehash := extcodehash(account)
        }
        return uint(codehash);
    }

    // ---------------------------------------------------------------
    // • for library use case
    // Example use:
    // require(LibProtector._protected());
    // --------------------------------------------------------------- 
    function _protected() internal view nonReentrant returns (bool) {
        return !isContract();
    }

    // Ensure the library is not used across multiple calls in the same transaction
    bool private _locked;
}

// example to use
// import "./LibProtector.sol";

contract MyContract {
    using LibProtector for LibProtector;

    // Example function using the _protected modifier
    function myFunction() external view LibProtector._protected returns (string memory) {
        // Your protected logic here
        return "Function executed successfully!";
    }

    // Example function that can be reentrant
    function myReentrantFunction() external view LibProtector.nonReentrant returns (string memory) {
        // Your reentrant logic here
        return "Reentrant function executed successfully!";
    }
}

*/
