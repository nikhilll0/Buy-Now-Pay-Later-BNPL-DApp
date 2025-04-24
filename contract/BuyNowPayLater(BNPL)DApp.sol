
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
    mapping(address => uint256[]) public buyerPurchases;
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
        buyerPurchases[_buyer].push(purchaseCounter);
        purchaseCounter++;
    }

    function payLater(uint256 _purchaseId) external payable {
        Purchase storage p = purchases[_purchaseId];
        require(msg.sender == p.buyer, "Not the buyer");
        require(!p.paid, "Already paid");
        require(msg.value == p.amount, "Incorrect amount");

        p.paid = true;
    }

    // 🔍 View all purchase IDs for the sender
    function getMyPurchases() external view returns (uint256[] memory) {
        return buyerPurchases[msg.sender];
    }

    // 💸 Refund a paid purchase (owner only)
    function refund(uint256 _purchaseId) external onlyOwner {
        Purchase storage p = purchases[_purchaseId];
        require(p.paid, "Purchase is not paid");
        p.paid = false;
        payable(p.buyer).transfer(p.amount);
    }

    // 🔄 Update unpaid purchase amount (owner only)
    function updatePurchaseAmount(uint256 _purchaseId, uint256 _newAmount) external onlyOwner {
        Purchase storage p = purchases[_purchaseId];
        require(!p.paid, "Can't update a paid purchase");
        p.amount = _newAmount;
    }

    // 📤 Withdraw ETH from the contract (owner only)
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // 💰 View current contract balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // 📋 Get all unpaid purchases for a buyer
    function getOutstandingPurchases(address _buyer) external view returns (uint256[] memory) {
        uint256[] memory all = buyerPurchases[_buyer];
        uint256 count;
        
        // First pass to count
        for (uint i = 0; i < all.length; i++) {
            if (!purchases[all[i]].paid) {
                count++;
            }
        }

        uint256[] memory result = new uint256[](count);
        uint j;

        // Second pass to collect unpaid IDs
        for (uint i = 0; i < all.length; i++) {
            if (!purchases[all[i]].paid) {
                result[j] = all[i];
                j++;
            }
        }

        return result;
    }
}
