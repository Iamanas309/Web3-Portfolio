# Foundry FundMe Project

The **FundMe Project** is a decentralized application built with [Foundry](https://book.getfoundry.sh/) that allows users to fund a contract using ETH, with price conversion powered by Chainlink oracles. The contract ensures that only the owner can withdraw the accumulated funds, providing a secure and transparent funding mechanism.

---

## 🔹 Features
- **Fund ETH:** Contributors can fund the contract with ETH.
- **Minimum USD Value:** Uses Chainlink price feeds to enforce a minimum contribution in USD terms.
- **Secure Withdrawals:** Only the contract owner can withdraw funds.
- **Gas-Efficient:** Optimized for low gas consumption.
- **Comprehensive Tests:** Built using Foundry’s testing framework.

---

## 🔹 Tech Stack
- **Language:** Solidity 0.8.30
- **Framework:** [Foundry](https://book.getfoundry.sh/)
- **Oracle:** [Chainlink Price Feeds](https://docs.chain.link/)

---

## 🔹 Project Structure
```
foundry-fund-me/
│
├── lib/
├── src/
├── script/
├── test/
├── foundry.toml
└── README.md   ← (this file)
```

---

## 🔹 How to Run Locally
1. Clone the repository:
   ```bash
   git clone https://github.com/Iamanas309/Web3-Portfolio.git
   ```
2. Navigate to the project folder:
   ```bash
   cd Web3-Portfolio/Solidity/foundry-fund-me
   ```
3. Install dependencies:
   ```bash
   forge install
   ```
4. Build the project:
   ```bash
   forge build
   ```
5. Run tests:
   ```bash
   forge test
   ```

---

## 📌 Part of My Web3 Journey
This project is part of my Web3 learning journey, where I explore Solidity, Foundry, and blockchain development by building practical projects.

---

### ✅ **Next Steps**
- Implement deployment scripts
- Add integration tests with live Chainlink oracles
- Deploy to a testnet

---

> **Author:** Anas  
> **GitHub:** [Iamanas309](https://github.com/Iamanas309)
