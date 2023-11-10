// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *    using TailRecursiveLoop for uint256;
 *    uint256 start = 10;
 *    uint256 end = 15;
 *    fn() { start.tailRecursiveForLoop(end, this.myCallback);}
 *  ```
 * then implementing requirment functions.
 *
 * important: in this code using "lambda", so lambda always is internal or external scope.
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library TailRecursiveLoop {
    function loop(uint256 start, uint256 end, function(uint256) external callback) internal {
        if (start <= end) {
            callback(start);
            loop(start + 1, end, callback);
        }
    }
    
    function tailRecursiveForLoop(uint256 start, uint256 end, function(uint256) external callback) internal {
        if (start <= end) {
            callback(start);
            tailRecursiveForLoop(start + 1, end, callback);
        }
    }

    function tailRecursiveWhileLoop(uint256 start, uint256 end, function(uint256) external callback) internal {
        if (start <= end) {
            callback(start);
            tailRecursiveWhileLoop(start + 1, end, callback);
        }
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


// example (how to use)
/*
contract MyContract {
    using TailRecursiveLoop for uint256;
    
    function myFunction() external {
        uint256 start = 0;
        uint256 end = 10;
        
        start.tailRecursiveForLoop(end, this.myCallback);
    }

    // lambda scope always external or internal
    function myCallback(uint256 iteration) external {
        // Perform your logic for each iteration here
        // This function will be called for each iteration of the loop
    }
    
    // ...
}
*/

// ..................................................................................
// behind the scenes:
// how to example logic worked as a lambda
/*
contract Parent {
    uint public parentVariable;

    function parentFunc(uint _parentVariable, function(uint) external _callback) public {
        parentVariable = _parentVariable;
        _callback(_parentVariable * 2);
    }
}

contract Child {
    address public parentAddress;
    uint public childVariable;

    constructor(address _parentAddress) {
        parentAddress = _parentAddress;
    }
    
    function run(uint _newVar) public {
        Parent(parentAddress).parentFunc(_newVar, this.callback);
    }
    
    // lambda scope always external or internal
    function callback(uint _childVariable) external {
        childVariable = _childVariable * 2;
    }
}
*/
