// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

contract DataStore {

    bytes32 public constant AUTHORIZED_CONTRACT_KEY = keccak256(abi.encodePacked("authorizedContract"));
    bytes32 public constant OWNER_KEY = keccak256(abi.encodePacked("owner"));
    
    mapping(bytes32 => bool) public boolValues;
    mapping(bytes32 => uint256) public uintValues;
    mapping(bytes32 => string) public stringValues;
    mapping(bytes32 => address) public addressValues;

    modifier onlyAuthorized(){
        require(addressValues[AUTHORIZED_CONTRACT_KEY] == msg.sender,"Only authorized addrress can call this function"); 
        _;
    }

    modifier onlyOwner(){
        require(addressValues[OWNER_KEY] == msg.sender,"Only owner can call this function"); 
        _;
    }

    constructor(address owner ){
        require(owner != address(0), "Address cannot be zero");
        addressValues[OWNER_KEY] = owner;
    }

    function setUint(bytes32 key,uint256 value)external onlyAuthorized{
        uintValues[key] = value;
    }

    function getUint(bytes32 key)external onlyAuthorized view returns (uint){
        return uintValues[key];
    }

    function removeUint(bytes32 key)external onlyAuthorized{
        delete uintValues[key];
    }

    function setAddress(bytes32 key ,address value)external onlyAuthorized{
        require(value != address(0), "Address cannot be zero");
        addressValues[key] = value;
    }

    function getAddress(bytes32 key )external onlyAuthorized view returns (address){
        return addressValues[key];
    }

    function removeAddress(bytes32 key)external onlyAuthorized{
        delete addressValues[key];
    }

    function setBool(bytes32 key)external onlyAuthorized{
        boolValues[key] = true;
    }

    function getBool(bytes32 key )external onlyAuthorized view returns (bool){
        return boolValues[key];
    }

    function removeBool(bytes32 key)external onlyAuthorized{
        delete boolValues[key];
    }

    function setString(bytes32 key,string memory value)external onlyAuthorized{
        stringValues[key] = value;
    }

    function getString(bytes32 key )external onlyAuthorized view returns (string memory){
        return stringValues[key];
    }

    function removeString(bytes32 key)external onlyAuthorized{
        delete stringValues[key];
    }

    // the one making the delegateCall will be the authorized address in our case its the router
    function updateAuthorizedContract(address newAddress)external onlyOwner {
        require(newAddress != address(0), "Address cannot be zero");
        addressValues[AUTHORIZED_CONTRACT_KEY] = newAddress;
    }

    function updateOwner(address newAddress)external onlyOwner {
        require(newAddress != address(0), "Address cannot be zero");
        addressValues[OWNER_KEY] = newAddress;
    }

    function getOwner()external onlyOwner view returns(address){
        return addressValues[OWNER_KEY];
    }
    
    function getAuthorizedAddress()external onlyOwner view returns(address){
        return addressValues[AUTHORIZED_CONTRACT_KEY];
    }


}