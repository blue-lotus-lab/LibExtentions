// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Portfolio Management, Based on erc20
 * 
 * disclaimer
 *
 * all solidity version 0.8.x compatible
 * test: solidity 0.8.22
 * openzeppelin v5 compatible
 * use this with your own risk, so always doing the security audit for production.
 *
 * Snippets created by: https://lotuschain.org {LibExtentions}
*/

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract PortfolioManagement is Ownable {
    using SafeERC20 for IERC20;
    using Address for address;

    struct Asset {
        string symbol;
        string pair;            // Trading pair symbol
        uint256 quantity;
        uint256 price;          // Price per unit in wei
        bool isERC20;           // True if the asset is an ERC-20 token
        address tokenAddress;   // ERC-20 token contract address
    }

    struct Portfolio {
        mapping(string => Asset) assets;
        string[] assetSymbols;  // Array to store asset symbols for iteration
    }

    mapping(address => Portfolio) private portfolios;

    event AssetAddedOrUpdated(address indexed user, string symbol, string pair, uint256 quantity, uint256 price, bool isERC20);
    event AssetRemoved(address indexed user, string symbol);

    constructor() Ownable(msg.sender) {}

    // Fallback function to reject Ether transfers
    // ! Additional data: we dont use payable function entire the code, so active this revert
    // At all, only in some cases need to eth into the smartcontract to doing the transaction.
    receive() external payable {
        // Enable next line when not using Native token (ETH)
        // revert("This contract does not accept Ether.");
    }

    function updateAsset(
        string memory _symbol,
        string memory _pair,
        uint256 _quantity,
        uint256 _price,
        bool _isERC20,
        address _tokenAddress
    ) external onlyOwner {
        require(_quantity > 0, "Quantity must be greater than zero");
        require(_price > 0, "Price must be greater than zero");

        Portfolio storage userPortfolio = portfolios[msg.sender];

        userPortfolio.assets[_symbol] = Asset(_symbol, _pair, _quantity, _price, _isERC20, _tokenAddress);

        if (!containsSymbol(userPortfolio.assetSymbols, _symbol)) {
            userPortfolio.assetSymbols.push(_symbol);
        }

        emit AssetAddedOrUpdated(msg.sender, _symbol, _pair, _quantity, _price, _isERC20);

        if (_isERC20) {
            IERC20(_tokenAddress).safeTransferFrom(msg.sender, address(this), _quantity);
        }
    }

    function removeAsset(string memory _symbol) external onlyOwner {
        Portfolio storage userPortfolio = portfolios[msg.sender];
        Asset storage asset = userPortfolio.assets[_symbol];

        require(asset.quantity > 0, "Asset not found in the portfolio");

        if (asset.isERC20) {
            IERC20(asset.tokenAddress).safeTransfer(msg.sender, asset.quantity);
        }

        delete userPortfolio.assets[_symbol];
        removeSymbol(userPortfolio.assetSymbols, _symbol);

        emit AssetRemoved(msg.sender, _symbol);
    }

    function getAsset(address _user, string memory _symbol) external view returns (Asset memory) {
        return portfolios[_user].assets[_symbol];
    }

    function getPortfolioValue(address _user) external view returns (uint256 totalValue) {
        Portfolio storage userPortfolio = portfolios[_user];
        uint tmp = userPortfolio.assetSymbols.length;

        for (uint256 i = 0; i < tmp; i++) {
            string memory symbol = userPortfolio.assetSymbols[i];
            Asset storage asset = userPortfolio.assets[symbol];
            totalValue += asset.quantity * asset.price;
        }

        return totalValue;
    }

    // Helper function to check if a symbol is in an array
    function containsSymbol(string[] memory _symbols, string memory _symbol) internal pure returns (bool) {
        for (uint256 i = 0; i < _symbols.length; i++) {
            if (keccak256(bytes(_symbols[i])) == keccak256(bytes(_symbol))) {
                return true;
            }
        }
        return false;
    }

    // Helper function to remove a symbol from an array
    function removeSymbol(string[] storage _symbols, string memory _symbol) internal {
        for (uint256 i = 0; i < _symbols.length; i++) {
            if (keccak256(bytes(_symbols[i])) == keccak256(bytes(_symbol))) {
                _symbols[i] = _symbols[_symbols.length - 1];
                _symbols.pop();
                return;
            }
        }
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
