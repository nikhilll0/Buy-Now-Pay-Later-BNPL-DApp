# Purchase Management Smart Contract

This Solidity smart contract enables the management of purchases including marking them as paid, tracking defaulted payments, and deleting unpaid records. It's designed to be controlled by an owner (admin) with read access for all users.

## Features

- **Mark purchases as paid**
- **Track total amount paid by a buyer**
- **List purchases by buyer**
- **Fetch purchase details**
- **Delete unpaid purchases (admin-only)**

---

## Contract Structure

### Data Structures

- `Purchase` struct (assumed definition):
  ```solidity
  struct Purchase {
      address buyer;
      uint256 amount;
      bool paid;
  }
