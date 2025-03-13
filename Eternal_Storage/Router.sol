// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import "./AccessModifiers.sol";

contract Router is AccessModifiers{

    address public logicContract;

    constructor (address _logicContract, address _storageAddress )AccessModifiers(_storageAddress){
        require(_logicContract!=address(0),"Address cannot be zero");
        logicContract = _logicContract;
    }

    function upgradeLogicContract(address newAddress)external onlyOwner{
        require(newAddress!=address(0),"Address cannot be zero");
        logicContract = newAddress;
    }
    
    function registerCandidate(address candidateAddress) external onlyOwner{ 
        (bool success, bytes memory data) = logicContract.delegatecall(
            abi.encodeWithSignature("registerCandidate(address)", candidateAddress)
        );
        if (!success) {
        if (data.length > 0) {
            assembly {
                let data_size := mload(data)
                revert(add(data, 32), data_size)
            }
        } else {
            revert("Delegatecall failed: Unknown error");
        }
    }
    }

     function removeCandidate(bytes32 key) external onlyOwner{
        (bool success, bytes memory data) = logicContract.delegatecall(
            abi.encodeWithSignature("removeCandidate(bytes32)", key)
        );
        if (!success) {
        if (data.length > 0) {
            assembly {
                let data_size := mload(data)
                revert(add(data, 32), data_size)
            }
        } else {
            revert("Delegatecall failed: Unknown error");
        }
    }
    }

    function addVote(bytes32 key,address voterAddress)external {
        (bool success, bytes memory data) = logicContract.delegatecall(
            abi.encodeWithSignature("addVote(bytes32,address)", key,voterAddress)
        );
        if (!success) {
        if (data.length > 0) {
            assembly {
                let data_size := mload(data)
                revert(add(data, 32), data_size)
            }
        } else {
            revert("Delegatecall failed: Unknown error");
        }
    }
    }

    function getVotes(bytes32 key)external returns(uint256){
        (bool success, bytes memory data) = logicContract.delegatecall(
            abi.encodeWithSignature("getVotes(bytes32)", key)
        );
        require(success, "Delegatecall failed");
       
        uint256 votes;
        assembly {
        votes := mload(add(data, 32)) 
        }

        return votes;
    }


}