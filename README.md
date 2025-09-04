# 🌾 Agricultural Traceability System

<div align="center">

![Solidity](https://img.shields.io/badge/Solidity-0.8.28-363636?style=for-the-badge&logo=solidity)
![Network](https://img.shields.io/badge/Network-ZeroScan-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

**Blockchain-based Farm-to-Consumer Traceability System**

</div>

---

## 🎯 Overview

Smart contract system for tracking agricultural products from farm to consumer, providing complete transparency and traceability in the food supply chain.

### ✨ Key Features

- 🏡 **Farm Management** - Register and manage multiple farms
- 🌾 **Product Tracking** - Complete product lifecycle tracking
- 🔬 **Process Monitoring** - Track agricultural processes (Farming, Medicine, Fertilizer, Harvest, Distribution)
- 🏆 **Certification System** - Multiple certification levels
- 👥 **Multi-User Support** - Role-based access control

## 🏗️ Project Structure

```
SmartContractTruyXuat/
├── src/                    # Source code
│   ├── contracts/         # Smart contracts
│   ├── scripts/           # Deployment scripts
│   └── test/              # Test files
├── docs/                  # Documentation
├── frontend/              # Frontend integration
│   ├── README.md          # Integration guide
│   ├── contract-config.js # Configuration
│   └── abi/               # Contract ABI
├── hardhat.config.js      # Hardhat configuration
└── package.json           # Dependencies
```

## 🚀 Quick Start

```bash
# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy to ZeroScan network
npx hardhat run src/scripts/deploy.js --network zeroscan
```

## 📊 Contract Information

- **Network**: ZeroScan (Chain ID: 5080)
- **Contract Address**: `0x8F6c1F3bb7561988ef6F749874690aA2450b039E`
- **Explorer**: https://zeroscan.org/address/0x8F6c1F3bb7561988ef6F749874690aA2450b039E

## 🏛️ Architecture

### 📋 Core Components

- **🏡 Farm Management** - Farm registration and management
- **🌾 Product Tracking** - Product lifecycle tracking
- **🔬 Agricultural Processes** - Farming, Medicine, Fertilizer, Harvest, Distribution
- **🔐 Security** - Role-based access control and validation

## 📚 Documentation

- **[📋 Usage Guide](docs/USAGE_GUIDE.md)** - How to use the contract
- **[🚀 Frontend Integration](frontend/README.md)** - Complete frontend integration guide

## 🎨 Frontend Integration

The `frontend/` directory contains everything needed for web integration. See `frontend/README.md` for detailed instructions.

## 📄 License

This project is licensed under the MIT License.

---

<div align="center">

### 🌾 **Built for Sustainable Agriculture**

**Blockchain-based farm-to-consumer traceability system**

</div>
