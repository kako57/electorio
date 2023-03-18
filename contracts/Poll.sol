// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

// import "hardhat/console.sol";

contract Poll {
  struct Candidate {
    string name;
    uint256 voteCount;
  }

  uint private nonce = 0;
  function _random() internal returns (uint) {
    uint number = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 100 + 1;
    nonce++;
    return number;
  }

  // we want the list of voters (an array of addresses)
  address[] public voters;
  // we want a list of candidates (an array of Candidate structs)
  Candidate[] public candidates;

  // we want a mapping of voters to booleans
  mapping (address => bool) public hasVoted;

  function addCandidate(string memory _name) public {
    candidates.push(Candidate(_name, 0));
  }

  function addVote(uint256 _candidateIndex) public {
    // check if the voter has already voted
    require(!hasVoted[msg.sender], "Voter has already voted");

    // check if the candidate index is valid
    require(_candidateIndex < candidates.length, "Invalid candidate index");
    
    // add the voter to the list of voters
    voters.push(msg.sender);

    // update the voter's voting status to true
    hasVoted[msg.sender] = true;

    // update the candidate's vote count
    candidates[_candidateIndex].voteCount++;

    // umm... why not be fair and random?
    // candidates[_candidateIndex].voteCount += _random();
  }

  function getVoteCount(uint256 _candidateIndex) public view returns (uint256) {
    // check if the candidate index is valid
    require(_candidateIndex < candidates.length, "Invalid candidate index");

    // return the vote count for the candidate
    return candidates[_candidateIndex].voteCount;
  }
}
