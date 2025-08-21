Similar and with references to the Solidity documentation, I have implemented an on-chain voting system implemented in Solidity. The contract allows the deployer to initialise a list of proposals, as well as granting voting rights to whitelisted addresses. These address are then able to cast their (single) votes for whichever proposal.

Features
- Initialize proposals by the contract deployer (leader)
- Grant voting rights to addresses exclusively by the leader
- Single vote per voter, enforced by contract logic
- View Functions: Retrieve proposal names (displayProposals) and vote counts (displayVoteCount).
- Winning Proposal: Determine the winning proposal based on vote counts (declareWinningProposal).
- Tie Handling: In the event of a tie, the contract resets vote counts and voter states, discarding previous round votes.

Usage Notes
- Proposal names must be passed as string values on contract deployment.
- Only the leader can assign voting rights, and declare winners.
- Voters can only vote once per round.
