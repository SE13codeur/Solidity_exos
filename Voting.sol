// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.2;

import "./Token.sol";

contract Voting is Ownable {
    enum VotingStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    struct Voting {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    VotingStatus public votingtatus;

    mapping(address => Voting) public voters;
    Proposal[] public proposals;

    uint public winningProposalId;

    modifier onlyDuringStatus(VotingStatus _status) {
        require(votingStatus == _status, "Invalid workflow status");
        _;
    }

    event VoterRegistered(address voterAddress);
    event VotingStatusChange(VotingStatus previousStatus, VotingStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted(address voter, uint proposalId);

    constructor() {
        votingStatus = VotingStatus.RegisteringVoters;
    }

    function changeVotingStatus(VotingStatus _newStatus) external onlyOwner {
        emit VotingStatusChange(votingStatus, _newStatus);
        votingStatus = _newStatus;
    }

    function registerVoter(address _voter) external onlyOwner onlyDuringStatus(VotingStatus.RegisteringVoters) {
        require(!voters[_voter].isRegistered, "Voter already registered");
        voters[_voter].isRegistered = true;
        emit VoterRegistered(_voter);
    }

    function startProposalsRegistration() external onlyOwner onlyDuringStatus(VotingStatus.RegisteringVoters) {
        changeVotingStatus(VotingStatus.ProposalsRegistrationStarted);
    }

    function endProposalsRegistration() external onlyOwner onlyDuringStatus(VotingStatus.ProposalsRegistrationStarted) {
        changeVotingStatus(VotingStatus.ProposalsRegistrationEnded);
    }

    function registerProposal(string memory _description) external onlyDuringStatus(VotingStatus.ProposalsRegistrationStarted) {
        require(voters[msg.sender].isRegistered, "Voter not registered");
        proposals.push(Proposal(_description, 0));
        emit ProposalRegistered(proposals.length - 1);
    }

    function startVotingSession() external onlyOwner onlyDuringStatus(VotingStatus.ProposalsRegistrationEnded) {
        changeVotingStatus(VotingStatus.VotingSessionStarted);
    }

    function endVotingSession() external onlyOwner onlyDuringStatus(VotingStatus.VotingSessionStarted) {
        changeVotingStatus(VotingStatus.VotingSessionEnded);
    }

    function vote(uint _proposalId) external onlyDuringStatus(VotingStatus.VotingSessionStarted) {
        require(voters[msg.sender].isRegistered, "Voter not registered");
        require(!voters[msg.sender].hasVoted, "Voter already voted");
        require(_proposalId < proposals.length, "Invalid proposal ID");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = _proposalId;
        proposals[_proposalId].voteCount++;
        emit Voted(msg.sender, _proposalId);
    }

    function tallyVotes() external onlyOwner onlyDuringStatus(VotingStatus.VotingSessionEnded) {
        uint winningVoteCount = 0;
        uint winningProposal = 0;

        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal = i;
            }
        }

        winningProposalId = winningProposal;
        changeVotingStatus(VotingStatus.VotesTallied);
    }

    function getWinner() external view returns (uint) {
        require(votingStatus == VotingStatus.VotesTallied, "Voting is ongoing");
        return winningProposalId;
    }
}
