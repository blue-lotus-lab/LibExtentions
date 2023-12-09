// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *   examples of "how to use" in buttom of this file
 *  ```
 * 
 * ! not limitation of use this foreach statement !
 *
 * you can inspire from it!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library ForEach {
    struct IterableMap {
        mapping(uint256 => bool) exists;
        uint256[] keys;
    }

    function add(IterableMap storage iterable, uint256 key) internal {
        require(!iterable.exists[key], "Key already exists");
        iterable.exists[key] = true;
        iterable.keys.push(key);
    }

    function forEach(IterableMap storage iterable, function(uint256) internal callback) internal {
        uint tmp = iterable.keys.length;
        for (uint256 i = 0; i < tmp; i++) {
            callback(iterable.keys[i]);
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

// ======================================================
// ================ LIST OF EXAMPLES ====================
// ======================================================
/*
// import "./ForEach.sol";

// Example
contract Example {
    using ForEach for ForEach.IterableMap;

    ForEach.IterableMap private iterableMap;

    event KeyProcessed(uint256 key);

    function addKey(uint256 key) external {
        iterableMap.add(key);
    }

    function processAllKeys() external {
        iterableMap.forEach(processKey);
    }

    function processKey(uint256 key) internal {
        // Do something with the key
        // For example, you can emit an event
        emit KeyProcessed(key);
    }
}


// usecase example
contract UserManagerExample {
    using ForEach for ForEach.IterableMap;
    ForEach.IterableMap private userKeys;

    struct User {
        string name;
        uint256 age;
    }

    mapping(uint256 => User) private users;

    event UserProcessed(uint256 userId, string userName, uint256 userAge);

    function addUser(uint256 userId, string memory userName, uint256 userAge) external {
        require(!userKeys.exists[userId], "User already exists");
        
        users[userId] = User({
            name: userName,
            age: userAge
        });

        userKeys.add(userId);
    }

    function processAllUsers() external {
        userKeys.forEach(processUser);
    }

    function processUser(uint256 userId) internal {
        User memory user = users[userId];

        // Perform some operation on the user
        // For example, you can emit an event with user details
        emit UserProcessed(userId, user.name, user.age);
    }
}
*/
