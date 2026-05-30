# Foundry Internship 🚀

Welcome to my **Foundry Internship** repository. This project is a comprehensive collection of smart contracts, deployment scripts, and rigorous security testing suites developed while completing the **Cyfrin Updraft - Foundry Fundamentals** course.

The core focus of this repository is mastering advanced web3 development, understanding **DeFi architecture**, optimizing **Gas consumption**, and implementing production-grade **Security Testing (Unit & Fuzzing)**.

---

## 🛠️ Tech Stack & Tools

- **Framework:** [Foundry](https://github.com/foundry-rs/foundry) (Forge, Cast, Anvil, Chisel)
- **Smart Contract Language:** Solidity
- **Layer 2 Integration:** ZKsync (`foundry-zksync`)
- **Oracles:** Chainlink (Price Feeds)
- **Platforms Covered:** Cyfrin Updraft, ZKsync Ecosystem

---

## 📁 Repository Structure

The repository is organized into distinct project modules, tracking progress from fundamental storage to advanced decentralized applications:

* **`foundry-simple-storage-cu`** / **`hello_foundry`**: The entry point to Foundry. Focuses on local environment setup, basic compilation, and understanding the Forge file structure.
* **`foundry-fund-me`**: A decentralized crowdfunding contract utilizing Chainlink Price Feeds. Features advanced deployment scripting, multi-network mocking, and gas-efficient storage patterns.
* **`foundry-zksync`**: Deep dive into Layer 2 execution, focusing on the architectural differences of deploying and testing smart contracts on ZKsync using `foundry-zksync`.

---

## 🚀 Key Features & Concepts Mastered

### 1. Advanced Security Testing
- **Unit Testing:** Writing robust test cases in Solidity using Forge standard libraries (`forge-std`).
- **Fuzz Testing:** Implementing stateless and stateful fuzzing to discover edge cases and boundary vulnerabilities.
- **Cheatcodes:** Leveraging powerful Forge cheatcodes like `vm.prank`, `vm.deal`, `vm.expectRevert`, and `vm.warp` to manipulate state and simulate complex attack vectors.

### 2. Gas Optimization
- Efficient utilization of `memory`, `storage`, and `calldata`.
- Implementing custom errors instead of verbose `require` strings to save deployment and execution gas.
- Using `immutable` and `constant` variables for fixed values.

### 3. Cross-Chain & Layer 2 Compatibility
- Deploying and verifying contracts locally using **Anvil** and specialized L2 environments (**ZKsync Anvil**).
- Writing flexible deploy scripts that dynamically adjust based on the network RPC (`mainnet`, `sepolia`, `zksync`).

---

## ⚙️ Getting Started

### Prerequisites

Ensure you have Foundry installed. If not, run:
```bash
curl -L [https://foundry.paradigm.xyz](https://foundry.paradigm.xyz) | bash
foundryup
