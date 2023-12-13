// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then
 *  ```
 *   import "./DefiErrorLibrary.sol";
 *   contract MyTokenContract {
 *       function getToken() external payable returns (bool) {
 *           if (msg.value <= 0) {
 *               DefiErrorLibrary.insufficientFunds(msg.sender, msg.value);
 *           }
 *           // Rest of the logic if the token exists
 *           return true;
 *       }
 *   }
 *  ```
 * 
 * ! not limitation of use this library statement !
 *
 * you can inspire from it!
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

error DefiErrors(uint256 errorCode, address user, uint256 amount);

library DefiErrorLibrary {
    function insufficientFunds(address user, uint256 amount) internal pure {
        revert DefiErrors(1, user, amount);
    }

    function invalidOperation(address user) internal pure {
        revert DefiErrors(2, user, 0);
    }

    function invalidToken(address user, address token) internal pure {
        revert DefiErrors(3, user, uint256(uint160(token)));
    }

    function unsupportedFeature(address user, uint256 featureCode) internal pure {
        revert DefiErrors(4, user, featureCode);
    }

    function marketNotAvailable(address user, address market) internal pure {
        revert DefiErrors(5, user, uint256(uint160(market)));
    }

    function invalidCollateral(address user, address collateral) internal pure {
        revert DefiErrors(6, user, uint256(uint160(collateral)));
    }

    function invalidBorrowedAmount(address user, uint256 borrowedAmount) internal pure {
        revert DefiErrors(7, user, borrowedAmount);
    }

    function liquidationThresholdReached(address user, address borrower) internal pure {
        revert DefiErrors(8, user, uint256(uint160(borrower)));
    }

    function invalidExchangeRate(address user, address oracle) internal pure {
        revert DefiErrors(10, user, uint256(uint160(oracle)));
    }

    function invalidInterestRateModel(address user, address interestRateModel) internal pure {
        revert DefiErrors(11, user, uint256(uint160(interestRateModel)));
    }

    function invalidFlashLoanProvider(address user, address provider) internal pure {
        revert DefiErrors(12, user, uint256(uint160(provider)));
    }

    function invalidFeeRecipient(address user, address recipient) internal pure {
        revert DefiErrors(13, user, uint256(uint160(recipient)));
    }

    function invalidOracleResponse(address user, address oracle) internal pure {
        revert DefiErrors(14, user, uint256(uint160(oracle)));
    }

    function invalidSwapRouter(address user, address router) internal pure {
        revert DefiErrors(15, user, uint256(uint160(router)));
    }

    function invalidGovernanceToken(address user, address token) internal pure {
        revert DefiErrors(16, user, uint256(uint160(token)));
    }

    function invalidStakingContract(address user, address stakingContract) internal pure {
        revert DefiErrors(17, user, uint256(uint160(stakingContract)));
    }

    function invalidWithdrawalLimit(address user, uint256 limit) internal pure {
        revert DefiErrors(18, user, limit);
    }

    function invalidCollateralizationRatio(address user, uint256 ratio) internal pure {
        revert DefiErrors(19, user, ratio);
    }

    function invalidRewardDistribution(address user, address distributor) internal pure {
        revert DefiErrors(20, user, uint256(uint160(distributor)));
    }

    // Add more custom errors as needed for your DeFi application
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
