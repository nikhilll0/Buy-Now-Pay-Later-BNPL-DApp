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
 contract address:- 0x83B548c21ECEF7A329D111B0E3d63700b8708F770
![Screenshot 2025-04-23 154211](https://github.com/user-attachments/assets/01418c1c-5081-4709-96ac-de3bd8c841d9)
