mapping(uint256 => bool) public defaulted;

function markAsDefaulted(uint256 _purchaseId) external onlyOwner {
    require(!purchases[_purchaseId].paid, "Already paid");
    defaulted[_purchaseId] = true;
}
function getTotalOutstandingAmount(address _buyer) external view returns (uint256) {
    uint256[] memory all = buyerPurchases[_buyer];
    uint256 total;

    for (uint i = 0; i < all.length; i++) {
        if (!purchases[all[i]].paid) {
            total += purchases[all[i]].amount;
        }
    }

    return total;
}
function hasOutstandingPurchases(address _buyer) external view returns (bool) {
    uint256[] memory all = buyerPurchases[_buyer];
    for (uint i = 0; i < all.length; i++) {
        if (!purchases[all[i]].paid) {
            return true;
        }
    }
    return false;
}
function transferPurchase(uint256 _purchaseId, address _newBuyer) external onlyOwner {
    Purchase storage p = purchases[_purchaseId];
    require(!p.paid, "Cannot transfer a paid purchase");

    // Remove from current buyer list
    uint256[] storage oldList = buyerPurchases[p.buyer];
    for (uint i = 0; i < oldList.length; i++) {
        if (oldList[i] == _purchaseId) {
            oldList[i] = oldList[oldList.length - 1];
            oldList.pop();
            break;
        }
    }

    // Add to new buyer list
    buyerPurchases[_newBuyer].push(_purchaseId);
    p.buyer = _newBuyer;
}
