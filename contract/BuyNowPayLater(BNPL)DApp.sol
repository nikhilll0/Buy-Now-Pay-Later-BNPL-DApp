function markAsPaid(uint256 _purchaseId) external onlyOwner {
    require(!purchases[_purchaseId].paid, "Already marked as paid");
    purchases[_purchaseId].paid = true;
    defaulted[_purchaseId] = false; // Clear default if it exists
}
function getPurchasesByBuyer(address _buyer) external view returns (uint256[] memory) {
    return buyerPurchases[_buyer];
}
function getPurchaseDetails(uint256 _purchaseId) external view returns (
    address buyer,
    uint256 amount,
    bool paid,
    bool isDefaulted
) {
    Purchase memory p = purchases[_purchaseId];
    return (p.buyer, p.amount, p.paid, defaulted[_purchaseId]);
}
function getTotalPaidAmount(address _buyer) external view returns (uint256) {
    uint256[] memory all = buyerPurchases[_buyer];
    uint256 total;

    for (uint i = 0; i < all.length; i++) {
        if (purchases[all[i]].paid) {
            total += purchases[all[i]].amount;
        }
    }

    return total;
}
function deletePurchase(uint256 _purchaseId) external onlyOwner {
    Purchase storage p = purchases[_purchaseId];
    require(!p.paid, "Cannot delete paid purchase");

    // Remove from buyer's list
    uint256[] storage list = buyerPurchases[p.buyer];
    for (uint i = 0; i < list.length; i++) {
        if (list[i] == _purchaseId) {
            list[i] = list[list.length - 1];
            list.pop();
            break;
        }
    }

    delete purchases[_purchaseId];
    delete defaulted[_purchaseId];
}

