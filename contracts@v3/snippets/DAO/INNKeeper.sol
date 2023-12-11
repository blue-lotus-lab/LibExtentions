// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Hotel Reservation System (Inn Keeper), Based on DAO, work by eth & erc20
 * "Hotel, Motel, Inn" automatic decentralized reserreservations 
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

// todo: in production not using timestamp, using oracle for time cinditions.

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract HotelReservationSystem is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using Address for address;

    struct Reservation {
        address guest;
        uint256 roomId;
        uint256 checkInDate;
        uint256 checkOutDate;
        bool isCancelled;
    }

    mapping(uint256 => Reservation) public reservations;
    mapping(uint256 => bool) public roomAvailability;

    address public ethFeeWallet;    // hotel/motel/inn wallet address for eth
    address public erc20FeeToken;   // hotel/motel/inn wallet address for erc20
    uint256 public ethFeeAmount;    // reservation fee amount in eth
    uint256 public erc20FeeAmount;  // reservation fee amount in erc20

    event ReservationMade(uint256 reservationId, address guest, uint256 roomId, uint256 checkInDate, uint256 checkOutDate);
    event ReservationCancelled(uint256 reservationId);

    constructor(address _ethFeeWallet, address _erc20FeeToken, uint256 _ethFeeAmount, uint256 _erc20FeeAmount) Ownable(msg.sender) {
        require(_ethFeeWallet != address(0), "Invalid ETH fee wallet address");
        require(_erc20FeeToken != address(0), "Invalid ERC20 fee token address");

        ethFeeWallet = _ethFeeWallet;
        erc20FeeToken = _erc20FeeToken;
        ethFeeAmount = _ethFeeAmount;
        erc20FeeAmount = _erc20FeeAmount;
    }

    modifier onlyGuest(uint256 _reservationId) {
        require(reservations[_reservationId].guest == msg.sender, "Not authorized");
        _;
    }

    modifier reservationNotCancelled(uint256 _reservationId) {
        require(!reservations[_reservationId].isCancelled, "Reservation already cancelled");
        _;
    }

    modifier checkCancellationDeadline(uint256 _checkInDate) {
        require(_checkInDate > block.timestamp.add(1 days), "Cannot cancel within 1 day of check-in");
        _;
    }

    function makeReservation(uint256 _roomId, uint256 _checkInDate, uint256 _checkOutDate) external payable {
        require(roomAvailability[_roomId], "Room not available");

        if (ethFeeAmount > 0) {
            require(msg.value == ethFeeAmount, "Incorrect ETH fee amount");
            Address.sendValue(payable(ethFeeWallet), msg.value);
        }

        if (erc20FeeAmount > 0) {
            IERC20(erc20FeeToken).safeTransferFrom(msg.sender, owner(), erc20FeeAmount);
        }

        uint256 reservationId = uint256(keccak256(abi.encodePacked(msg.sender, block.number, block.timestamp)));
        reservations[reservationId] = Reservation({
            guest: msg.sender,
            roomId: _roomId,
            checkInDate: _checkInDate,
            checkOutDate: _checkOutDate,
            isCancelled: false
        });

        roomAvailability[_roomId] = false;

        emit ReservationMade(reservationId, msg.sender, _roomId, _checkInDate, _checkOutDate);
    }

    function cancelReservation(uint256 _reservationId) external onlyGuest(_reservationId) reservationNotCancelled(_reservationId) checkCancellationDeadline(reservations[_reservationId].checkInDate) {
        reservations[_reservationId].isCancelled = true;
        roomAvailability[reservations[_reservationId].roomId] = true;

        emit ReservationCancelled(_reservationId);
    }

    function updateEthFeeWallet(address newEthFeeWallet) external onlyOwner {
        require(newEthFeeWallet != address(0), "Invalid ETH fee wallet address");
        ethFeeWallet = newEthFeeWallet;
    }

    function updateErc20FeeToken(address newErc20FeeToken) external onlyOwner {
        require(newErc20FeeToken != address(0), "Invalid ERC20 fee token address");
        erc20FeeToken = newErc20FeeToken;
    }

    function updateEthFeeAmount(uint256 newEthFeeAmount) external onlyOwner {
        ethFeeAmount = newEthFeeAmount;
    }

    function updateErc20FeeAmount(uint256 newErc20FeeAmount) external onlyOwner {
        erc20FeeAmount = newErc20FeeAmount;
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
