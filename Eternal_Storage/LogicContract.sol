// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import "./DataStore.sol";
import "./AccessModifiers.sol";

contract LogicContract is AccessModifiers{
  
    constructor(address _storageAddress)AccessModifiers(_storageAddress){
    }

    function registerCandidate(address candidateAddress) external onlyOwner {
        require(candidateAddress != address(0), "Address cannot be zero");
        bytes32 candidateKey = keccak256(abi.encodePacked("candidate", candidateAddress));
        require(!dataStorage.getBool(candidateKey), "Candidate already registered");
        dataStorage.setBool(candidateKey);
    }

    function removeCandidate(bytes32 key) external onlyOwner{
        require(dataStorage.getBool(key), "Candidate not registered");
        dataStorage.removeBool(key);
    }

    function addVote(bytes32 key,address voterAddress)external {
        require(dataStorage.boolValues(key),"Candidate not registerred");
        bytes32 voterKey = keccak256(abi.encodePacked("voter",voterAddress));
        require(!dataStorage.getBool(voterKey),"Vote already registered");
        uint existingVotes = dataStorage.getUint(key);
        uint votes=existingVotes + 1;
        dataStorage.setUint(key,votes);
        dataStorage.setBool(voterKey);
    }

    function getVotes(bytes32 key)external view returns(uint256){
        require(dataStorage.getBool(key), "Candidate not registered");
        return dataStorage.getUint(key);
    }

}