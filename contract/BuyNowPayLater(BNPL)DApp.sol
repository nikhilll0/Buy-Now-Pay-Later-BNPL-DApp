// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BNPL {
    address public owner;

    struct Purchase {
        address buyer;
        uint256 amount;
        bool paid;
    }

    mapping(uint256 => Purchase) public purchases;
    uint256 public purchaseCounter;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createPurchase(address _buyer, uint256 _amount) external onlyOwner {
        purchases[purchaseCounter] = Purchase(_buyer, _amount, false);
        purchaseCounter++;
    }

    function payLater(uint256 _purchaseId) external payable {
        Purchase storage p = purchases[_purchaseId];
        require(msg.sender == p.buyer, "Not the buyer");
        require(!p.paid, "Already paid");
        require(msg.value == p.amount, "Incorrect amount");

        p.paid = true;
    }
}

