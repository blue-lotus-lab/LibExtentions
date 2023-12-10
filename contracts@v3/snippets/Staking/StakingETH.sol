// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Staking Pool Reward, Native stak & reward ERC20, Work with block number
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
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract ETHStaking is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using Address for address;

    IERC20 public rewardToken;
    uint256 public rewardRate;
    uint256 public lastRewardBlock;
    uint256 public totalStaked;
    uint256 public rewardPool;
    uint256 public stakingPeriod;
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public lastClaimBlock;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event ClaimedRewards(address indexed user, uint256 amount);
    event DepositedIntoPool(address indexed depositor, uint256 amount);

    modifier onlyPositiveAmount(uint256 amount) {
        require(amount > 0, "Amount must be greater than 0");
        _;
    }

    modifier onlyDuringStakingPeriod() {
        require(block.number.sub(lastClaimBlock[msg.sender]) <= stakingPeriod, "Staking period expired");
        _;
    }

    constructor(IERC20 _rewardToken, uint256 _rewardRate, uint256 _stakingPeriod) Ownable(msg.sender) {
        rewardToken = _rewardToken;
        rewardRate = _rewardRate;
        stakingPeriod = _stakingPeriod;
        lastRewardBlock = block.number;
    }

    function stake() external payable onlyPositiveAmount(msg.value) {
        updateReward();
        stakedBalance[msg.sender] = stakedBalance[msg.sender].add(msg.value);
        totalStaked = totalStaked.add(msg.value);
        emit Staked(msg.sender, msg.value);
    }

    function unstake(uint256 amount) external onlyPositiveAmount(amount) onlyDuringStakingPeriod {
        updateReward();
        stakedBalance[msg.sender] = stakedBalance[msg.sender].sub(amount);
        totalStaked = totalStaked.sub(amount);
        // payable(msg.sender).transfer(amount);
        Address.sendValue(payable(msg.sender), amount);
        emit Unstaked(msg.sender, amount);
    }

    function claimRewards() external onlyDuringStakingPeriod {
        updateReward();
        uint256 reward = calculateReward(msg.sender);
        require(reward > 0, "No rewards to claim");
        lastClaimBlock[msg.sender] = block.number;
        rewardToken.safeTransfer(msg.sender, reward);
        emit ClaimedRewards(msg.sender, reward);
    }

    function depositIntoPool(uint256 amount) external onlyPositiveAmount(amount) {
        rewardToken.safeTransferFrom(msg.sender, address(this), amount);
        rewardPool = rewardPool.add(amount);
        emit DepositedIntoPool(msg.sender, amount);
    }

    function updateReward() internal {
        uint256 currentBlock = block.number;
        uint256 blocksSinceLastReward = currentBlock.sub(lastRewardBlock);
        uint256 rewards = totalStaked.mul(rewardRate).mul(blocksSinceLastReward);
        rewards = rewards.add(rewardPool);
        lastRewardBlock = currentBlock;
        rewardToken.safeTransferFrom(owner(), address(this), rewards);
        rewardPool = 0;
    }

    function calculateReward(address user) internal view returns (uint256) {
        uint256 blocksStaked = block.number.sub(lastClaimBlock[user]);
        return stakedBalance[user].mul(rewardRate).mul(blocksStaked <= stakingPeriod ? blocksStaked : stakingPeriod);
    }

    function withdrawTokensFromPool(uint256 amount) external onlyOwner onlyPositiveAmount(amount) {
        require(amount <= rewardPool, "Insufficient reward pool balance");
        rewardToken.safeTransfer(owner(), amount);
        rewardPool = rewardPool.sub(amount);
    }

    receive() external payable {
        // Allow the contract to receive ETH
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
