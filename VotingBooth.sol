// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingBooth{

    struct Proposal {
        string name;     // Proposal name
        uint voteCount;   // Number of accumulated votes
    }

    struct Voter {
        bool voted;
        uint weight;
        uint vote;
    }

    address private leader;
    mapping (address => Voter) public voters;
    Proposal[] public proposals;
    address[] private voterList;
    bool tie;

    constructor(string[] memory proposalNames){
        leader = msg.sender;
        voters[leader].weight = 1;


        for (uint i = 0; i < proposalNames.length; i++){
            proposals.push(Proposal(proposalNames[i],0));
        }
    }

    function allowVotingRights(address voter) external {
        require(msg.sender == leader, "No permissions");
        require(voters[voter].voted != true, "Already voted");
        require(voters[voter].weight == 0 , "Already has rights");
        voters[voter].weight = 1;
        voterList.push(voter);
    }

    function displayProposals() external view returns (string[] memory){
        string[] memory names = new string[](proposals.length);
        for (uint i = 0; i < proposals.length; i++){
            names[i] = proposals[i].name; 
        }
        return names;
    }

    function displayVoteCount() external view returns (uint[] memory){
        uint[] memory count = new uint[](proposals.length);
        for (uint i = 0; i < proposals.length; i++){
            count[i] = proposals[i].voteCount;
        }
        return count;
    }

    function vote(uint proposal) external{
        require(voters[msg.sender].voted == false, "Already voted");
        require(voters[msg.sender].weight == 1, "No voting rights");
        require(proposal < proposals.length, "Invalid proposal ID");
        proposals[proposal].voteCount += 1;
        voters[msg.sender].voted = true;
    }

    function tieEvent() private {
        tie = false;
        for (uint i = 0;  i <  proposals.length; i++){
            proposals[i].voteCount = 0;
        }
        for (uint i = 0; i < voterList.length; i++){
            address voter = voterList[i];
            voters[voter].voted = false;
        }
    }

    function getWinningProposal() private returns (uint winningProposal_){
        uint winningVoteCount = 0;
        for (uint i = 0; i < proposals.length; i++){
            if (proposals[i].voteCount > winningVoteCount){
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
        for (uint i = 0; i < proposals.length; i++){
            if (proposals[i].voteCount == winningVoteCount && i != winningProposal_){
                tie = true;
            }
        }
    }

    function declareWinningProposal() external returns(string memory) {
        require(msg.sender == leader, "Invalid user");
        if (tie){
            tieEvent();
            return ("There is a tie between proposals, please vote again");
        } else {
            uint winningIndex = getWinningProposal();
            string memory winnerName = proposals[winningIndex].name;
            return(winnerName);
        }
    }        
}
