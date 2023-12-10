// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Escrow, Judge Observer edition, Support native token
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
import {Ownable} from  "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from  "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Escrow is Ownable, ReentrancyGuard {
    address public payer;
    address public payee;
    address public judge;
    uint public amount;
    bool public payerApproved;
    bool public payeeApproved;
    bool public judgeApproved;
    bool public releaseApproved;
    bool public refundApproved;

    enum State { Created, Locked, Released, Refunded }
    State public state;

    modifier onlyPayer() {
        require(msg.sender == payer, "Only payer can call this function");
        _;
    }

    modifier onlyPayee() {
        require(msg.sender == payee, "Only payee can call this function");
        _;
    }

    modifier onlyJudge() {
        require(msg.sender == judge, "Only judge can call this function");
        _;
    }

    modifier inState(State _state) {
        require(state == _state, "Invalid state");
        _;
    }

    event FundsDeposited(address indexed payer, uint amount);
    event Approved(address indexed participant);
    event Released();
    event Refunded();

    constructor(address _payee, address _judge) Ownable(payer) {
        payer = msg.sender;
        payee = _payee;
        judge = _judge;
        state = State.Created;
    }

    receive() external payable {
        // revert("Fallback function not allowed");
    }

    function deposit() external payable onlyPayer inState(State.Created) nonReentrant {
        amount = msg.value;
        emit FundsDeposited(payer, amount);
        state = State.Locked;
    }

    function approve() external nonReentrant {
        require(state == State.Locked, "Invalid state for approval");
        if (msg.sender == payer) {
            payerApproved = true;
        } else if (msg.sender == payee) {
            payeeApproved = true;
        } else if (msg.sender == judge) {
            judgeApproved = true;
        }

        emit Approved(msg.sender);

        if (payerApproved && payeeApproved) {
            release();
        } else if (payerApproved && judgeApproved) {
            refund();
        }
    }

    function release() private onlyPayer inState(State.Locked) nonReentrant {
        emit Released();
        state = State.Released;
        payable(payee).transfer(amount);
    }

    function refund() private onlyPayer inState(State.Locked) nonReentrant {
        emit Refunded();
        state = State.Refunded;
        payable(payer).transfer(amount);
    }

    function observeRelease() external onlyJudge inState(State.Locked) nonReentrant {
        require(!payerApproved && payeeApproved, "Invalid state for observation");
        release();
    }

    function observeRefund() external onlyJudge inState(State.Locked) nonReentrant {
        require(payerApproved && !payeeApproved, "Invalid state for observation");
        refund();
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
