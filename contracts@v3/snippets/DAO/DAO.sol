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
 * tips: use a factory contract to use this from dao-dapp
 *
 * Snippets created by: https://lotuschain.org {LibExtentions}
*/

// dao - based on block number 

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract DAO is Ownable, Pausable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    using Address for address;

    struct Proposal {
        address creator;
        string description;
        uint yesVotes;
        uint noVotes;
        bool executed;
        uint expirationBlock;
        mapping(address => bool) hasVoted;
    }

    mapping(uint => Proposal) public proposals;
    uint public proposalCount;
    uint public immutable minimumVotes;

    IERC20 public votingToken;

    event ProposalCreated(uint proposalId, address creator, string description, uint expirationBlock);
    event Voted(uint proposalId, address voter, bool vote);
    event ProposalExecuted(uint proposalId, address executor);

    modifier proposalExists(uint _proposalId) {
        require(_proposalId < proposalCount, "Proposal does not exist");
        _;
    }

    modifier notExecuted(uint _proposalId) {
        require(!proposals[_proposalId].executed, "Proposal has already been executed");
        _;
    }

    modifier notVoted(uint _proposalId) {
        require(!proposals[_proposalId].hasVoted[msg.sender], "You have already voted on this proposal");
        _;
    }

    modifier proposalNotExpired(uint _proposalId) {
        require(block.number < proposals[_proposalId].expirationBlock, "Proposal has expired");
        _;
    }

    constructor(address _votingTokenAddress, uint _minimumVotes) Ownable(msg.sender) {
        votingToken = IERC20(_votingTokenAddress);
        minimumVotes = _minimumVotes;
    }

    // Fallback function to receive ether
    receive() external payable {}

    function createProposal(string memory _description, uint _blocksDuration) external whenNotPaused {
        uint proposalId = proposalCount++;
        uint expirationBlock = block.number + _blocksDuration;

        Proposal storage newProposal = proposals[proposalId];
        newProposal.creator = msg.sender;
        newProposal.description = _description;
        newProposal.yesVotes = 0;
        newProposal.noVotes = 0;
        newProposal.executed = false;
        newProposal.expirationBlock = expirationBlock;

        emit ProposalCreated(proposalId, msg.sender, _description, expirationBlock);
    }

    function vote(uint _proposalId, bool _vote) 
    external 
    proposalExists(_proposalId) 
    notExecuted(_proposalId) 
    notVoted(_proposalId) 
    proposalNotExpired(_proposalId) 
    nonReentrant 
    whenNotPaused {
        Proposal storage proposal = proposals[_proposalId];

        if (_vote) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }

        proposal.hasVoted[msg.sender] = true;

        emit Voted(_proposalId, msg.sender, _vote);
    }

    function executeProposal(uint _proposalId) 
    external 
    proposalExists(_proposalId) 
    notExecuted(_proposalId) 
    proposalNotExpired(_proposalId) 
    nonReentrant 
    whenNotPaused {
        Proposal storage proposal = proposals[_proposalId];

        require(proposal.yesVotes > proposal.noVotes, "Proposal did not receive enough votes");
        require(proposal.yesVotes + proposal.noVotes >= minimumVotes, "Votes count not enough");

        proposal.executed = true;
        // Charge 1 voting token to execute
        votingToken.safeTransferFrom(msg.sender, address(this), 1);

        // Execute the proposal's action here
        // For example, transfer funds to the creator
        Address.sendValue(payable(proposal.creator), address(this).balance);

        emit ProposalExecuted(_proposalId, msg.sender);
    }

    function withdrawTokens(address _tokenAddress, uint _amount) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.safeTransfer(owner(), _amount);
    }

    // Pause and unpause functions
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
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
