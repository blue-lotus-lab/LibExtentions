// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Staking Pool Reward, Non native token
 * 
 * disclaimer
 *
 * all solidity version 0.8.x compatible
 * test: solidity 0.8.22
 * openzeppelin v5 compatible
 * use this with your own risk, so always doing the security audit for production.
 *
 * Snippets created by: https://lotuschain.org {LibExtentions}
*/

import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ERC20Staking is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public token; // The ERC-20 token being staked
    uint256 public rewardRate; // Base reward rate per block
    uint256 public lastRewardBlock; // Block number of the last reward
    uint256 public totalStaked; // Total staked tokens
    uint256 public rewardPool; // Reward pool for boosting rewards
    uint256 public stakingPeriod; // Duration (in blocks) for calculating staking rewards
    mapping(address => uint256) public stakedBalance; // Staked balances
    mapping(address => uint256) public lastClaimBlock; // Last block number when a user claimed rewards

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event ClaimedRewards(address indexed user, uint256 amount);
    event DepositedIntoPool(address indexed depositor, uint256 amount);

    constructor(IERC20 _token, uint256 _rewardRate, uint256 _stakingPeriod) Ownable(msg.sender) {
        token = _token;
        rewardRate = _rewardRate;
        stakingPeriod = _stakingPeriod;
        lastRewardBlock = block.number;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        updateReward();
        token.safeTransferFrom(msg.sender, address(this), amount);
        stakedBalance[msg.sender] = stakedBalance[msg.sender].add(amount);
        totalStaked = totalStaked.add(amount);
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(amount > 0 && amount <= stakedBalance[msg.sender], "Invalid amount");
        updateReward();
        token.safeTransfer(msg.sender, amount);
        stakedBalance[msg.sender] = stakedBalance[msg.sender].sub(amount);
        totalStaked = totalStaked.sub(amount);
        emit Unstaked(msg.sender, amount);
    }

    function claimRewards() external {
        updateReward();
        uint256 reward = calculateReward(msg.sender);
        require(reward > 0, "No rewards to claim");
        lastClaimBlock[msg.sender] = block.number;
        token.safeTransfer(msg.sender, reward);
        emit ClaimedRewards(msg.sender, reward);
    }

    function depositIntoPool(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        token.safeTransferFrom(msg.sender, address(this), amount);
        rewardPool = rewardPool.add(amount);
        emit DepositedIntoPool(msg.sender, amount);
    }

    function updateReward() internal {
        uint256 currentBlock = block.number;
        uint256 blocksSinceLastReward = currentBlock.sub(lastRewardBlock);
        uint256 rewards = totalStaked.mul(rewardRate).mul(blocksSinceLastReward);
        rewards = rewards.add(rewardPool); // Include reward pool
        lastRewardBlock = currentBlock;
        token.safeTransferFrom(owner(), address(this), rewards);
        rewardPool = 0; // Reset reward pool after distribution
    }

    function calculateReward(address user) internal view returns (uint256) {
        uint256 blocksStaked = block.number.sub(lastClaimBlock[user]);
        if (blocksStaked > stakingPeriod) {
            blocksStaked = stakingPeriod; // Cap the staking period
        }

        return stakedBalance[user].mul(rewardRate).mul(blocksStaked);
    }

    // Owner function to update the reward rate
    function updateRewardRate(uint256 _rewardRate) external onlyOwner {
        rewardRate = _rewardRate;
        updateReward();
    }

    // Owner function to update the staking period
    function updateStakingPeriod(uint256 _stakingPeriod) external onlyOwner {
        stakingPeriod = _stakingPeriod;
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
