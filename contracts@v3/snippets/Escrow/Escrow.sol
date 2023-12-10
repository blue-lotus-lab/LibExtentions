// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Escrow, Non native token
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

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract Escrow is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    using Address for address;

    address public payer;
    address public payee;
    uint256 public amount;
    IERC20 public token;
    bool public payerApproved;
    bool public payeeApproved;

    enum State { Created, Locked, Released, Refunded }
    State public state;

    modifier onlyPayerOrPayee() {
        require(_msgSender() == payer || _msgSender() == payee, "Only payer or payee can call this function");
        _;
    }

    modifier inState(State _state) {
        require(state == _state, "Invalid state");
        _;
    }

    event FundsDeposited(address indexed payer, uint256 amount);
    event Approved(address indexed participant);
    event Released();
    event Refunded();

    constructor(address _payee, address _token) Ownable(msg.sender) {
        require(_payee != address(0), "Invalid payee address");
        // isContract check token currection in constructor just for check when deploy
        require(isContract(_token), "Invalid token address");

        payer = _msgSender();
        payee = _payee;
        token = IERC20(_token);
        state = State.Created;
    }

    // Fallback function to reject direct Ether transfers
    receive() external payable {
        revert("Fallback function not allowed");
    }

    function isContract(address _address) internal view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_address)
        }
        return (size > 0);
    }

    function setPayeeAddress(address _payee) external onlyOwner {
        require(_payee != address(0), "Invalid payee address");
        payee = _payee;
    }

    function deposit(uint256 _amount) external onlyOwner inState(State.Created) nonReentrant {
        require(_amount > 0, "Amount must be greater than 0");
        amount = _amount;
        token.safeTransferFrom(_msgSender(), address(this), amount);
        emit FundsDeposited(payer, amount);
        state = State.Locked;
    }

    function approve() external onlyPayerOrPayee nonReentrant {
        require(state == State.Locked, "Invalid state for approval");

        if (_msgSender() == payer) {
            payerApproved = true;
        } else if (_msgSender() == payee) {
            payeeApproved = true;
        }

        emit Approved(_msgSender());

        if (payerApproved && payeeApproved) {
            release();
        }
    }

    function release() private onlyOwner inState(State.Locked) nonReentrant {
        emit Released();
        state = State.Released;
        token.safeTransfer(payee, amount);
    }

    function refund() external onlyPayerOrPayee inState(State.Locked) nonReentrant {
        require(payerApproved && !payeeApproved, "Invalid state for refund");
        emit Refunded();
        state = State.Refunded;
        token.safeTransfer(payer, amount);
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
