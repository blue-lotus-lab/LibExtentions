// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *    using IncomeSharingLibrary for IncomeSharingLibrary.IncomeSharing;
 *    IncomeSharingLibrary.IncomeSharing private incomeSharing;
 *  ```
 * then implementing requirment functions.
 * security: using checks in functions to ensure about the user was added or removed before. 
 * in this case using "onlyOwner" or user role.
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

import {Address} from "@openzeppelin/contracts/utils/Address.sol";

library IncomeSharingLibrary {
    using Address for address;

    struct Wallet {
        address walletAddress;
        uint256 sharePercentage;
    }

    struct IncomeSharing {
        mapping(address => Wallet) wallets;
        address[] walletAddresses;
    }

    function addWallet(IncomeSharing storage self, address walletAddress, uint256 sharePercentage) external {
        require(sharePercentage > 0, "Share percentage must be greater than zero");
        require(sharePercentage <= 100, "Share percentage must be less than or equal to 100");
        require(self.wallets[walletAddress].walletAddress == address(0), "Wallet already exists");

        self.wallets[walletAddress] = Wallet(walletAddress, sharePercentage);
        self.walletAddresses.push(walletAddress);
    }

    function removeWallet(IncomeSharing storage self, address walletAddress) external {
        require(self.wallets[walletAddress].walletAddress != address(0), "Wallet does not exist");

        delete self.wallets[walletAddress];
        for (uint256 i = 0; i < self.walletAddresses.length; i++) {
            if (self.walletAddresses[i] == walletAddress) {
                self.walletAddresses[i] = self.walletAddresses[self.walletAddresses.length - 1];
                self.walletAddresses.pop();
                break;
            }
        }
    }

    function changeSharePercentage(IncomeSharing storage self, address walletAddress, uint256 newSharePercentage) external {
        require(newSharePercentage > 0, "Share percentage must be greater than zero");
        require(newSharePercentage <= 100, "Share percentage must be less than or equal to 100");
        require(self.wallets[walletAddress].walletAddress != address(0), "Wallet does not exist");

        self.wallets[walletAddress].sharePercentage = newSharePercentage;
    }

    function distributeIncome(IncomeSharing storage self, uint256 income) external {
        require(self.walletAddresses.length > 0, "No wallets added");

        uint256 totalSharePercentage = 0;
        for (uint256 i = 0; i < self.walletAddresses.length; i++) {
            totalSharePercentage += self.wallets[self.walletAddresses[i]].sharePercentage;
        }

        require(totalSharePercentage <= 100, "Total share percentage exceeds 100");

        for (uint256 i = 0; i < self.walletAddresses.length; i++) {
            address walletAddress = self.walletAddresses[i];
            uint256 share = (income * self.wallets[walletAddress].sharePercentage) / 100;
            // Transfer the share to the wallet address
            Address.sendValue(payable(walletAddress), share);
        }
    }

    function showWallet(IncomeSharing storage self, address walletAddress) external view returns (address _a, uint256 _b) {
        if(
            self.wallets[walletAddress].walletAddress != address(0) && 
            self.wallets[walletAddress].sharePercentage > 0 
        ) {
            _a = walletAddress;
            _b = self.wallets[walletAddress].sharePercentage;
        } else {
            _a = address(0);
            _b = 0;
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

// ****************************************************************
// how to use:

/*
import "./IncomeSharingLibrary.sol";

contract MyContract {
    using IncomeSharingLibrary for IncomeSharingLibrary.IncomeSharing;
    IncomeSharingLibrary.IncomeSharing private incomeSharing;

    constructor() {
        // Initialize the income sharing data
        incomeSharing.addWallet(address(0x123), 50);
        incomeSharing.addWallet(address(0x456), 30);
        incomeSharing.addWallet(address(0x789), 20);
    }

    function addWallet(address walletAddress, uint256 sharePercentage) external onlyOwner {
        incomeSharing.addWallet(walletAddress, sharePercentage);
    }

    function removeWallet(address walletAddress) external onlyOwner {
        incomeSharing.removeWallet(walletAddress);
    }

    function changeSharePercentage(address walletAddress, uint256 newSharePercentage) external onlyOwner {
        incomeSharing.changeSharePercentage(walletAddress, newSharePercentage);
    }

    function distributeIncome(uint256 income) external onlyOwner {
        incomeSharing.distributeIncome(income);
    }
}
*/

// ****************************************************************
// The use of "self." in the code snippets I provided is a convention commonly used in Solidity to refer to 
// the current instance of a struct or contract.
// "self" is used to refer to the instance of the IncomeSharing struct within the library.

// more info: 
// actualy solidity not have "self" but have "this" keyword. 
// liberaries have limitation to use variables. so using struct and the user defination types is the solution.
