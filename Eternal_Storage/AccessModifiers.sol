// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import "./DataStore.sol";

contract AccessModifiers {
    DataStore internal dataStorage;
  
    constructor(address _storageAddress){
        require(_storageAddress!=address(0),"Address cannot be zero");
        dataStorage = DataStore(_storageAddress);
    }

    modifier onlyAuthorized(){
        bytes32 key=dataStorage.AUTHORIZED_CONTRACT_KEY();       
        require(dataStorage.getAddress(key) == msg.sender,"Only authorized addrress can call this function"); 
        _;
    }

    modifier onlyOwner(){
        bytes32 key=dataStorage.OWNER_KEY();
        require(dataStorage.getAddress(key) == msg.sender,"Only owner can call this function"); 
        _;
    }

}