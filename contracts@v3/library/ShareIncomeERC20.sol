// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *    using ShareIncomeLibrary for IERC20;
 *    fn() { ShareIncomeLibrary.distributeIncome(tokenAddress, recipients, amounts);}
 *    fn_fee() { ShareIncomeLibraryFee.distributeIncome(tokenAddress, recipients, amounts, feePercentage);}
 *  ```
 * then implementing requirment functions.
 *
 * important: some times need to be in safe scope, like "onlyOwner" or role controler.
 * remember to add validation checks in code, like amount > 0, and shares equal 100.
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

library ShareIncomeLibrary {
    using SafeERC20 for IERC20;

    event IncomeDistributed(address indexed token, address indexed distributor, address[] recipients, uint256[] amounts);

    function distributeIncome(address tokenAddress, address[] memory recipients, uint256[] memory amounts) external {
        require(recipients.length == amounts.length, "Invalid input");

        IERC20 token = IERC20(tokenAddress);
        uint256 totalAmount = 0;

        // Convert the loop to tail recursion
        distributeIncomeHelper(token, recipients, amounts, totalAmount, 0);

        emit IncomeDistributed(tokenAddress, msg.sender, recipients, amounts);
    }

    function distributeIncomeHelper(IERC20 token, address[] memory recipients, uint256[] memory amounts, uint256 totalAmount, uint256 index) private {
        if (index < recipients.length) {
            totalAmount += amounts[index];
            token.safeTransferFrom(msg.sender, address(this), amounts[index]);
            token.safeTransfer(recipients[index], amounts[index]);
            distributeIncomeHelper(token, recipients, amounts, totalAmount, index + 1);
        }
    }
}


// tail-recursive version
library ShareIncomeLibraryFee {
    using SafeERC20 for IERC20;

    event IncomeDistributed(address indexed token, address indexed distributor, address[] recipients, uint256[] amounts);

    function distributeIncome(address tokenAddress, address[] memory recipients, uint256[] memory amounts, uint256 feePercentage) external {
        require(recipients.length == amounts.length, "Invalid input");
        require(feePercentage <= 5, "max fee is 5%");

        IERC20 token = IERC20(tokenAddress);
        uint256 totalAmount = 0;

        for (uint256 i = 0; i < recipients.length; i++) {
            totalAmount += amounts[i];
        }

        uint256 feeAmount = (totalAmount * feePercentage) / 100;
        uint256 distributedAmount = totalAmount - feeAmount;

        token.safeTransferFrom(msg.sender, address(this), totalAmount);

        distributeIncomeHelper(token, recipients, amounts, distributedAmount, totalAmount, 0);

        emit IncomeDistributed(tokenAddress, msg.sender, recipients, amounts);
    }

    function distributeIncomeHelper(IERC20 token, address[] memory recipients, uint256[] memory amounts, uint256 distributedAmount, uint256 totalAmount, uint256 index) private {
        if (index == recipients.length) {
            return;
        }

        uint256 recipientAmount = (distributedAmount * amounts[index]) / totalAmount;
        token.safeTransfer(recipients[index], recipientAmount);

        distributeIncomeHelper(token, recipients, amounts, distributedAmount, totalAmount, index + 1);
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

// when use loop to generate these libraries
/*
library ShareIncomeLibrary {
    using SafeERC20 for IERC20;

    event IncomeDistributed(address indexed token, address indexed distributor, address[] recipients, uint256[] amounts);

    function distributeIncome(address tokenAddress, address[] memory recipients, uint256[] memory amounts) external {
        require(recipients.length == amounts.length, "Invalid input");

        IERC20 token = IERC20(tokenAddress);
        uint256 totalAmount = 0;

        for (uint256 i = 0; i < recipients.length; i++) {
            totalAmount += amounts[i];
        }

        token.safeTransferFrom(msg.sender, address(this), totalAmount);

        for (uint256 i = 0; i < recipients.length; i++) {
            token.safeTransfer(recipients[i], amounts[i]);
        }

        emit IncomeDistributed(tokenAddress, msg.sender, recipients, amounts);
    }
}

library ShareIncomeLibraryFee {
    using SafeERC20 for IERC20;

    event IncomeDistributed(address indexed token, address indexed distributor, address[] recipients, uint256[] amounts);

    function distributeIncome(address tokenAddress, address[] memory recipients, uint256[] memory amounts, uint256 feePercentage) external {
        require(recipients.length == amounts.length, "Invalid input");
        require(feePercentage <= 5, "max fee is 5%");

        IERC20 token = IERC20(tokenAddress);
        uint256 totalAmount = 0;

        for (uint256 i = 0; i < recipients.length; i++) {
            totalAmount += amounts[i];
        }

        uint256 feeAmount = (totalAmount * feePercentage) / 100;
        uint256 distributedAmount = totalAmount - feeAmount;

        token.safeTransferFrom(msg.sender, address(this), totalAmount);

        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 recipientAmount = (distributedAmount * amounts[i]) / totalAmount;
            token.safeTransfer(recipients[i], recipientAmount);
        }

        emit IncomeDistributed(tokenAddress, msg.sender, recipients, amounts);
    }
}
*/

// test examples
/*
contract test1 {
    using ShareIncomeLibrary for IERC20;
    
    function buy(address tokenAddress, address[] memory recipients, uint256[] memory amounts) external payable { 
        // some codes
        ShareIncomeLibrary.distributeIncome(tokenAddress, recipients, amounts);
    }
}

contract test2 {
    using ShareIncomeLibraryFee for IERC20;
    
    function buy(address tokenAddress, address[] memory recipients, uint256[] memory amounts, uint256 feePercentage) external payable { 
        // some codes
        ShareIncomeLibraryFee.distributeIncome(tokenAddress, recipients, amounts, feePercentage);
    }
}
*/
