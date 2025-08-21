Similar and with references to the Solidity documentation, I have implemented an on-chain voting system implemented in Solidity. The contract allows the deployer to initialise a list of proposals, as well as granting voting rights to whitelisted addresses. These address are then able to cast their (single) votes for whichever proposal.

Features
- Initialize proposals by the contract deployer (leader)
- Grant voting rights to addresses exclusively by the leader
- Single vote per voter, enforced by contract logic
- Retrieve proposal names and their corresponding vote counts
- Determine and declare the winning proposal based on vote counts

Usage Notes
- Proposal names must be passed as bytes32 values on contract deployment (use padding or helper tools).
- Only the leader can assign voting rights, keeping control over who may vote.
- Voters can only vote once.
- Results can be queried by any external user at any time.
