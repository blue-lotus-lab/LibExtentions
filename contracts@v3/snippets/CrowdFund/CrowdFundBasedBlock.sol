// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Crowd FundRaising, Based on block
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

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Crowdfunding is ReentrancyGuard {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct Campaign {
        address creator;
        uint256 goal;
        uint256 raised;
        uint256 endBlock;
        mapping(address => uint256) contributions;
        bool isFunded;
    }

    mapping(uint256 => Campaign) public campaigns;

    address public erc721Token;
    address public erc20Token;

    uint256 public campaignCounter;

    event CampaignCreated(uint256 indexed id, address indexed creator, uint256 goal, uint256 endBlock);
    event ContributionMade(uint256 indexed id, address indexed contributor, uint256 amount);
    event CampaignFunded(uint256 indexed id, address indexed creator, uint256 amount);
    event Withdrawal(uint256 indexed id, address indexed contributor, uint256 amount);
    event InvestmentRevoked(uint256 indexed id, address indexed contributor, uint256 amount);

    modifier hasToken() {
        require(IERC721(erc721Token).balanceOf(msg.sender) > 0, "Sender must own an ERC-721 token");
        _;
    }

    modifier validCampaign(uint256 id) {
        Campaign storage campaign = campaigns[id];
        require(campaign.creator != address(0), "Campaign does not exist");
        require(!campaign.isFunded, "Campaign is already funded");
        require(block.number < campaign.endBlock, "Campaign has ended");
        _;
    }

    constructor(address _erc721Token, address _erc20Token) {
        erc721Token = _erc721Token;
        erc20Token = _erc20Token;
    }

    // Fallback function to reject direct Ether transfers
    receive() external payable {
        revert("Ether not accepted");
    }

    function createCampaign(uint256 _goal, uint256 _blockDuration) external hasToken {
        require(_goal > 0, "Goal must be greater than zero");

        uint256 endBlock = block.number + _blockDuration;
        campaignCounter++;

        Campaign storage newCampaign = campaigns[campaignCounter];
        newCampaign.creator = msg.sender;
        newCampaign.goal = _goal;
        newCampaign.endBlock = endBlock;
        newCampaign.raised = 0;
        newCampaign.isFunded = false;

        emit CampaignCreated(campaignCounter, msg.sender, _goal, endBlock);
    }

    function contribute(uint256 id, uint256 amount) external nonReentrant validCampaign(id) {
        require(amount > 0, "Contribution amount must be greater than zero");

        IERC20(erc20Token).safeTransferFrom(msg.sender, address(this), amount);

        Campaign storage campaign = campaigns[id];
        campaign.contributions[msg.sender] = campaign.contributions[msg.sender].add(amount);
        campaign.raised = campaign.raised.add(amount);

        emit ContributionMade(id, msg.sender, amount);

        if (campaign.raised >= campaign.goal) {
            campaign.isFunded = true;
            emit CampaignFunded(id, campaign.creator, campaign.raised);
        }
    }

    function withdraw(uint256 id) external nonReentrant validCampaign(id) {
        Campaign storage campaign = campaigns[id];
        require(campaign.isFunded, "Campaign is not fully funded");
        require(campaign.creator == msg.sender, "Only the campaign creator can withdraw");

        uint256 amount = campaign.raised;
        IERC20(erc20Token).safeTransfer(msg.sender, amount);

        emit Withdrawal(id, msg.sender, amount);
    }

    function revokeInvestment(uint256 id) external nonReentrant validCampaign(id) {
        Campaign storage campaign = campaigns[id];
        require(!campaign.isFunded, "Cannot revoke investment after the campaign is funded");

        uint256 contributorBalance = campaign.contributions[msg.sender];

        require(contributorBalance > 0, "No investment to revoke");

        IERC20(erc20Token).safeTransfer(msg.sender, contributorBalance);

        emit InvestmentRevoked(id, msg.sender, contributorBalance);

        // Reset the contributor's balance to zero
        campaign.contributions[msg.sender] = 0;
        campaign.raised = campaign.raised.sub(contributorBalance);
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
