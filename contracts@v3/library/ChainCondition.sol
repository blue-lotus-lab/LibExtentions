// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *   examples of "how to use" in buttom of this file
 *  ```
 * 
 * ! not limitation of use this condition statement !
 *
 * setup the gas optimization for use this. you can inspire from it!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library ChainOfIfStatements {
    struct Condition {
        bool isTrue;
        string statement;
    }

    function checkConditions(Condition[] memory conditions) external pure returns (string memory) {
        for (uint256 i = 0; i < conditions.length; i++) {
            if (conditions[i].isTrue) {
                return conditions[i].statement;
            }
        }
        
        return "No condition is true";
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
// import "./ChainOfIfStatements.sol";

// usecase example 1
contract ExampleContract {
    using ChainOfIfStatements for ChainOfIfStatements.Condition[];

    function checkConditions() external pure returns (string memory) {
        ChainOfIfStatements.Condition[] memory conditions = new ChainOfIfStatements.Condition[](3);

        // Add conditions as needed
        conditions[0] = ChainOfIfStatements.Condition(true, "Condition 1 is true");
        conditions[1] = ChainOfIfStatements.Condition(false, "Condition 2 is true");
        conditions[2] = ChainOfIfStatements.Condition(true, "Condition 3 is true");

        return conditions.checkConditions();
    }
}

// usecase example 2
contract AccessControlExample {
    using ChainOfIfStatements for ChainOfIfStatements.Condition[];

    enum Role { Guest, Member, Admin }
    address immutable own;
    constructor() {
        own = msg.sender;
    }

    function owner() public view returns (address) {
        return own;
    }

    function getUserRole(address user) external view returns (Role) {
        ChainOfIfStatements.Condition[] memory conditions = new ChainOfIfStatements.Condition[](3);

        conditions[0] = ChainOfIfStatements.Condition(user == owner(), "Admin");
        conditions[1] = ChainOfIfStatements.Condition(isMember(user), "Member");
        conditions[2] = ChainOfIfStatements.Condition(true, "Guest");

        string memory roleString = conditions.checkConditions();
        
        if (keccak256(bytes(roleString)) == keccak256(bytes("Admin"))) {
            return Role.Admin;
        } else if (keccak256(bytes(roleString)) == keccak256(bytes("Member"))) {
            return Role.Member;
        } else {
            return Role.Guest;
        }
    }

    function isMember(address user) internal view returns (bool) {
        // Implement your membership logic here
        // ...
    }
}

// usecase example 3
contract VestingContractExample {
    using ChainOfIfStatements for ChainOfIfStatements.Condition[];
    
    struct VestingCondition {
        bool isMet;
        uint256 releaseAmount;
    }

    mapping(address => VestingCondition[]) public vestingConditions;

    address immutable own;
    uint startTime;
    constructor() {
        own = msg.sender;
        startTime = block.timestamp;
    }

    function owner() public view returns (address) {
        return own;
    }

    function releaseTokens(address beneficiary) external {
        VestingCondition[] storage conditions = vestingConditions[beneficiary];

        // Add vesting conditions as needed
        conditions.push(VestingCondition(block.timestamp >= startTime, 1000));
        conditions.push(VestingCondition(beneficiary == owner(), 2000));
        conditions.push(VestingCondition(true, 500));

        uint256 totalReleased = 0;
        for (uint256 i = 0; i < conditions.length; i++) {
            if (conditions[i].isMet) {
                // Release tokens based on the first true condition
                totalReleased += conditions[i].releaseAmount;
                conditions[i].isMet = false; // Mark the condition as executed
            }
        }

        // Implement token transfer logic with the totalReleased amount
        // ...
    }
}
*/
