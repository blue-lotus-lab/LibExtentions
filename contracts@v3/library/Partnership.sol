// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev How to use:
 * first import library, then for example
 *  ```
 *  using LibPartner for partner;
 *  
 *    function fx(address _address) public view returns (bool) {
 *        return partner.isPartner(_address);
 *    }
 *  
 *    function fx(address _address) public PartnerCheck(msg.sender) {
 *        // code here
 *    }
 *  ```
 * then implementing requirment functions.
 * security: using checks in functions to ensure about the user was added or removed before. 
 * in this case can to using "onlyOwner" or user role.
 *
 * Library created by: https://lotuschain.org {LibExtentions}
*/

library LibPartner {
    struct LibData {
        // example (0 to 15 percent): 15 
        uint8 MAX_PERCENTAGE; // = 15;
        // offer or percent of sell
        uint8 _programPercentage; // = 10;  
        // 10 percent// program-user -> is true?
        mapping(address => bool) _programAccount;
    }

    event AddPartner(address indexed account);
    event RemovePartner(address indexed account);
    event SetPartnerPercent(uint8 indexed percent);

    error OnlyRegisteredPartners(address partner);

    modifier PartnerCheck(LibData storage _lib, address who) { // virtual
        if(!_lib._programAccount[who]) revert OnlyRegisteredPartners(who);
        _;
    }

    // ---------------------------------------------------------------
    // • programs 
    // ---------------------------------------------------------------
    // override all virtual's by user role like onlyOwner
    
    // —→ setter:
    function addColleagueAccount(LibData storage _lib, address toAddAddress) public { // virtual onlyOwner
        require(_lib._programAccount[toAddAddress] == false, "Already exist");
        _lib._programAccount[toAddAddress] = true;
        emit AddPartner(toAddAddress);
    }
	
    // —→ setter:
    function removeColleagueAccount(LibData storage _lib, address toRemoveAddress) public { // virtual onlyOwner
        require(_lib._programAccount[toRemoveAddress] == true, "Not Partnere");
        delete _lib._programAccount[toRemoveAddress];
        emit RemovePartner(toRemoveAddress);
    }

    // —→ setter:
    function addColleagueAccounts(LibData storage _lib, address[] calldata toAddAddresses) public { // virtual onlyOwner
        addColleagueAccountRecursive(_lib, toAddAddresses, 0);
    }
	
    // —→ setter:
    function removeColleagueAccounts(LibData storage _lib, address[] calldata toRemoveAddresses) public { // virtual onlyOwner
        removeColleagueAccountRecursive(_lib, toRemoveAddresses, 0);
    }
	
    // »—— config:
    function addColleagueAccountRecursive(LibData storage _lib, address[] calldata toAddAddresses, uint index) private {
        if (index < toAddAddresses.length && _lib._programAccount[toAddAddresses[index]] == false) {
                _lib._programAccount[toAddAddresses[index]] = true;
                emit AddPartner(toAddAddresses[index]);
                addColleagueAccountRecursive(_lib, toAddAddresses, index + 1);
        }
    }
	
    // »—— config:
    function removeColleagueAccountRecursive(LibData storage _lib, address[] calldata toRemoveAddresses, uint index) private {
        if (index < toRemoveAddresses.length && _lib._programAccount[toRemoveAddresses[index]] == true) {
                delete _lib._programAccount[toRemoveAddresses[index]];
                emit RemovePartner(toRemoveAddresses[index]);
                removeColleagueAccountRecursive(_lib, toRemoveAddresses, index + 1);
        }
    }

    // —→ setter:	
	function setMaxPercent(LibData storage _lib, uint8 percentage) public { // virtual onlyOwner
        require(percentage <= 15, "Percentage: 0 and 15");
        _lib.MAX_PERCENTAGE = percentage;
        emit SetPartnerPercent(percentage);
    }

    // —→ setter:	
	function setProgramPercent(LibData storage _lib, uint8 percentage) public { // virtual onlyOwner
        require(percentage <= _lib.MAX_PERCENTAGE, "Percentage: 0 and 15");
        _lib._programPercentage = percentage;
        emit SetPartnerPercent(percentage);
    }

    // ←— getter:
    function getMaxPercent(LibData storage _lib) public view returns (uint8) {
        return _lib.MAX_PERCENTAGE;
    }

    // ←— getter:
    function getProgramPercent(LibData storage _lib) public view returns (uint8) {
        return _lib._programPercentage;
    }

    // ←— getter:
    function isPartner(LibData storage _lib) public view returns (bool) {
        return _lib._programAccount[msg.sender];
    }

    // ←— getter:
    function isPartner(LibData storage _lib, address who) public view returns (bool) {
        return _lib._programAccount[who];
    }

    // ---------------------------------------------------------------
    // • programs features
    // --------------------------------------------------------------- 
    // override all virtual's by user role like onlyOwner

    // —— helper:
    function hashPartner(address toAddAddress) internal pure returns (bytes32) {
        return keccak256(abi.encode(toAddAddress));
    }
}

/* ----------------------------------------------------------------------------------
[
    { 
        "creator": "lotuschain-lab",
        "web3-home": "https://lotuschain.org",
        "ALT-id": "@ALT"
    }
]
---------------------------------------------------------------------------------- */
