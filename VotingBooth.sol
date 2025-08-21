// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingBooth{

    struct Proposal {
        bytes32 name;     // Proposal name
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
    bool tie;

    constructor(bytes32[] memory proposalNames){
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
    }

    function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
        uint8 length = 0;
        // Count length until null byte
        while(length < 32 && _bytes32[length] != 0) {
            length++;
        }

        bytes memory bytesArray = new bytes(length);
        for (uint8 i = 0; i < length; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }

    function displayProposals() external view returns (string[] memory){
        string[] memory names = new string[](proposals.length);
        for (uint i = 0; i < proposals.length; i++){
            names[i] = bytes32ToString(proposals[i].name); 
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
        proposals[proposal].voteCount += 1;
        voters[msg.sender].voted = true;
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
        if (tie){
            tie = false;
            return ("There is a tie between proposals, please vote again");
        } else {
            uint winningIndex = getWinningProposal();
            string memory winnerName = bytes32ToString(proposals[winningIndex].name);
            return(winnerName);
        }
        
    }        
}
