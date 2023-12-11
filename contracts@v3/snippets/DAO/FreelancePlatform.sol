// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * FreelancePlatform (Job Boarding), Based on milestone, as a dao
 * 
 * disclaimer
 *
 * all solidity version 0.8.x compatible
 * test: solidity 0.8.22
 * openzeppelin v5 compatible
 * use this with your own risk, so always doing the security audit for production.
 *
 * tips: possible to use a factory contract to use this from dao-dapp, in your need
 *
 * Snippets created by: https://lotuschain.org {LibExtentions}
*/

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract FreelancePlatform is Ownable {
    using SafeERC20 for IERC20;
    IERC20 public token;

    enum JobStatus { Open, Closed, Completed }

    struct JobListing {
        address client;
        string projectDetails;
        uint256 budget;
        uint256 deadline;
        JobStatus status;
        address selectedFreelancer;
        uint256 paidAmount;
        mapping(address => uint256) milestones;
    }

    struct JobSeeker {
        string talents;
        string resume;
        string portfolio;
        bool isAvailable;
        uint256 reputation;
    }

    mapping(address => JobListing) public jobListings;
    mapping(address => JobSeeker) public jobSeekers;

    event JobListingCreated(address indexed jobAddress, address indexed client, string projectDetails, uint256 budget, uint256 deadline);
    event JobApplication(address indexed jobAddress, address indexed seeker, string talents, string resume, string portfolio);
    event JobAssigned(address indexed jobAddress, address indexed client, address indexed freelancer);
    event MilestoneSet(address indexed jobAddress, address indexed client, uint256 amount);
    event MilestoneReleased(address indexed jobAddress, address indexed client, uint256 amount);
    event JobCompleted(address indexed jobAddress, address indexed client, address indexed freelancer);

    modifier onlyClient(address jobAddress) {
        require(msg.sender == jobListings[jobAddress].client, "Only the client can call this function");
        _;
    }

    modifier onlySeeker() {
        require(bytes(jobSeekers[msg.sender].talents).length > 0, "Only job seekers can call this function");
        _;
    }

    modifier onlyOpenJob(address jobAddress) {
        require(jobListings[jobAddress].status == JobStatus.Open, "Job is not open");
        _;
    }

    modifier onlyAvailableSeeker() {
        require(jobSeekers[msg.sender].isAvailable, "Job seeker is not available");
        _;
    }

    modifier onlyFreelancer(address jobAddress) {
        require(msg.sender == jobListings[jobAddress].selectedFreelancer, "Only the selected freelancer can call this function");
        _;
    }

    constructor(address _tokenAddress) Ownable(msg.sender) {
        token = IERC20(_tokenAddress);
    }

    function createJobListing(string memory _projectDetails, uint256 _budget, uint256 _deadline) external {
        require(_budget > 0, "Budget must be greater than 0");
        require(_deadline > block.timestamp, "Deadline must be in the future");

        address jobAddress = address(bytes20(sha256(abi.encodePacked(msg.sender, block.timestamp))));

        JobListing storage newJob = jobListings[jobAddress];
        newJob.client = msg.sender;
        newJob.projectDetails = _projectDetails;
        newJob.budget = _budget;
        newJob.deadline = _deadline;
        newJob.status = JobStatus.Open;
        newJob.selectedFreelancer = address(0);
        newJob.paidAmount = 0;

        emit JobListingCreated(jobAddress, msg.sender, _projectDetails, _budget, _deadline);
    }

    function applyForJob(address jobAddress, string memory _talents, string memory _resume, string memory _portfolio) external onlySeeker {
        require(jobListings[jobAddress].client != address(0), "Job does not exist");
        require(jobSeekers[msg.sender].isAvailable, "Job seeker is not available");
        require(jobListings[jobAddress].status == JobStatus.Open, "Job is not open");

        emit JobApplication(jobAddress, msg.sender, _talents, _resume, _portfolio);
    }

    function selectFreelancer(address jobAddress, address freelancer) external onlyClient(jobAddress) onlyOpenJob(jobAddress) onlyAvailableSeeker {
        jobListings[jobAddress].status = JobStatus.Closed;
        jobListings[jobAddress].selectedFreelancer = freelancer;

        emit JobAssigned(jobAddress, msg.sender, freelancer);
    }

    function setMilestone(address jobAddress, uint256 amount) external onlyClient(jobAddress) onlyOpenJob(jobAddress) {
        require(amount > 0 && amount <= jobListings[jobAddress].budget, "Invalid milestone amount");

        jobListings[jobAddress].milestones[msg.sender] = amount;

        emit MilestoneSet(jobAddress, msg.sender, amount);
    }

    function releaseMilestone(address jobAddress) external onlyClient(jobAddress) onlyFreelancer(jobAddress) {
        uint256 milestoneAmount = jobListings[jobAddress].milestones[msg.sender];
        require(milestoneAmount > 0, "No milestone set by the client");

        jobListings[jobAddress].milestones[msg.sender] = 0;
        jobListings[jobAddress].paidAmount += milestoneAmount;

        // Transfer tokens using a safer transferFrom function
        token.safeTransferFrom(jobListings[jobAddress].client, msg.sender, milestoneAmount);

        emit MilestoneReleased(jobAddress, msg.sender, milestoneAmount);

        // Check if all milestones are paid and mark the job as completed
        if (jobListings[jobAddress].paidAmount == jobListings[jobAddress].budget) {
            jobListings[jobAddress].status = JobStatus.Completed;
            emit JobCompleted(jobAddress, jobListings[jobAddress].client, jobListings[jobAddress].selectedFreelancer);
        }
    }

    function getReputation(address jobSeekerAddress) external view returns (uint256) {
        return jobSeekers[jobSeekerAddress].reputation;
    }

    function withdrawTokens(uint256 amount) external onlyOwner {
        token.safeTransfer(owner(), amount);
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
