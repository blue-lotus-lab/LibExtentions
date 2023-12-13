// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Vote to Proposal, DAO branch, Based on 7 days
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

contract VoteProposalDAO {
    address public owner;
    uint256 public votingEndTime;
    uint256 public proposalCount;

    enum ProposalStatus { Pending, Accepted, Rejected }

    struct Proposal {
        address proposer;
        string description;
        ProposalStatus status;
        uint256 blockNumber;
        uint256 yesVotes;
        uint256 noVotes;
        address[] voters;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public proposalVotes;

    event ProposalSubmitted(uint256 proposalId, address proposer, string description, uint256 blockNumber);
    event VoteCasted(uint256 proposalId, address voter, bool inFavor);
    event ProposalFinalized(uint256 proposalId, ProposalStatus status);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyBeforeVotingEnd() {
        require(block.timestamp < votingEndTime, "Voting has ended");
        _;
    }

    modifier onlyValidProposal(uint256 proposalId) {
        require(proposalId < proposalCount, "Invalid proposal ID");
        _;
    }

    constructor() {
        owner = msg.sender;
        votingEndTime = block.timestamp + 7 days; // Voting period is 7 days
    }

    function submitProposal(string memory description) external onlyBeforeVotingEnd {
        uint256 currentBlock = block.number;
        uint256 proposalId = proposalCount++;

        proposals[proposalId] = Proposal({
            proposer: msg.sender,
            description: description,
            status: ProposalStatus.Pending,
            blockNumber: currentBlock,
            yesVotes: 0,
            noVotes: 0,
            voters: new address[](0)
        });

        emit ProposalSubmitted(proposalId, msg.sender, description, currentBlock);
    }

    function vote(uint256 proposalId, bool inFavor) external onlyBeforeVotingEnd onlyValidProposal(proposalId) {
        Proposal storage proposal = proposals[proposalId];

        require(proposal.status == ProposalStatus.Pending, "Proposal has already been finalized");
        require(!proposalVotes[proposalId][msg.sender], "You have already voted");

        if (inFavor) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }

        proposalVotes[proposalId][msg.sender] = true;
        proposal.voters.push(msg.sender);

        emit VoteCasted(proposalId, msg.sender, inFavor);
    }

    function finalizeProposal(uint256 proposalId) external onlyOwner onlyValidProposal(proposalId) {
        Proposal storage proposal = proposals[proposalId];

        require(block.timestamp >= votingEndTime, "Voting is still ongoing");
        require(proposal.status == ProposalStatus.Pending, "Proposal has already been finalized");

        if (proposal.yesVotes > proposal.noVotes) {
            proposal.status = ProposalStatus.Accepted;
        } else {
            proposal.status = ProposalStatus.Rejected;
        }

        emit ProposalFinalized(proposalId, proposal.status);
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
