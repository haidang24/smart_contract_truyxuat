# 🌾 Agricultural Traceability System

<div align="center">

![Solidity](https://img.shields.io/badge/Solidity-0.8.28-363636?style=for-the-badge&logo=solidity)
![Hardhat](https://img.shields.io/badge/Hardhat-2.22.0-f7df1e?style=for-the-badge&logo=ethereum)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Network](https://img.shields.io/badge/Network-ZeroScan-green?style=for-the-badge)

**Blockchain-based Farm-to-Consumer Traceability System**

[📖 Documentation](#-documentation) • [🚀 Quick Start](#-quick-start) • [🏗️ Architecture](#️-architecture) • [🔧 Development](#-development)

</div>

---

## 🎯 Overview

A comprehensive smart contract system for tracking agricultural products from farm to consumer, providing complete transparency and traceability in the food supply chain.

### ✨ Key Features

- 🏡 **Farm Management** - Register and manage multiple farms per user
- 🌾 **Product Tracking** - Complete product lifecycle tracking
- 🔬 **Process Monitoring** - Track 5 agricultural processes (Farming, Medicine, Fertilizer, Harvest, Distribution)
- 🏆 **Certification System** - Multiple certification levels (Basic, Organic, Premium, Certified)
- 🖼️ **Image Management** - Support up to 10 images per farm
- 👥 **Multi-User Support** - Role-based access control
- 📱 **Frontend Ready** - Complete integration packages for web apps

## 🏗️ Project Structure

```
SmartContractTruyXuat/
├── src/                          # Source code
│   ├── contracts/               # Smart contracts
│   │   └── truyxuat.sol        # Main traceability contract
│   ├── scripts/                # Deployment scripts
│   │   └── deploy.js           # Main deployment script
│   └── test/                   # Test files
│       └── AgriculturalTraceabilityTest.js
├── docs/                       # Documentation
│   ├── README.md              # Project documentation
│   └── USAGE_GUIDE.md         # Usage guide
├── frontend/                   # Frontend integration
│   ├── AgriculturalTraceabilitySystem.json  # Contract ABI
│   ├── contract-config.js     # Configuration
│   ├── api-examples.js        # API wrapper
│   ├── react-hooks.js         # React hooks
│   ├── FRONTEND_INTEGRATION_GUIDE.md
│   ├── INTEGRATION_CHECKLIST.md
│   └── QUICK_START.md
├── build/                      # Build artifacts (auto-generated)
├── node_modules/              # Dependencies
├── hardhat.config.js          # Hardhat configuration
├── package.json               # Project dependencies
└── info-address-truyxuat.json # Deployed contract address
```

## 🚀 Quick Start

### Prerequisites

- Node.js (v16+)
- npm or yarn
- MetaMask browser extension

### Installation

```bash
# Clone repository
git clone <repository-url>
cd SmartContractTruyXuat

# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy to ZeroScan network
npx hardhat run src/scripts/deploy.js --network zeroscan

# Verify contract
npx hardhat verify --network zeroscan <CONTRACT_ADDRESS>
```

## 📊 Contract Information

### 🌐 Network Details
- **Network**: ZeroScan
- **Chain ID**: 5080
- **RPC URL**: https://rpc.zeroscan.org
- **Explorer**: https://zeroscan.org

### 📝 Contract Address
```
0x8F6c1F3bb7561988ef6F749874690aA2450b039E
```

### 🔧 Contract Features
- **44 Functions** - Complete API for farm-to-consumer tracking
- **13+ Events** - Real-time blockchain logging
- **Gas Optimized** - Deployment-optimized settings
- **Security** - Role-based access control and input validation

## 🏛️ Architecture

### 📋 Core Components

#### 🏡 Farm Management
```solidity
struct Farm {
    string farmCode;      // Unique farm identifier
    string fullname;      // Farm owner name
    string nameFarm;      // Farm name
    string userId;        // User ID
    string email;         // Contact email
    string phone;         // Contact phone
    string description;   // Farm description
    string location;      // Geographic location
    uint256 area;         // Farm area in m²
    string[] images;      // Farm images (max 10)
    uint256 createdAt;    // Creation timestamp
    bool isActive;        // Active status
}
```

#### 🌾 Product Tracking
```solidity
struct Product {
    string farmCode;              // Associated farm
    string productCode;           // Unique product identifier
    string categoryName;          // Product category
    string name;                  // Product name
    string quantity;              // Quantity
    string price;                 // Price
    string description;           // Description
    string image;                 // Product image
    string batchCode;             // Batch code
    string certification;         // Certification info
    uint256 createdAt;           // Creation timestamp
    ProductStatus status;         // Product status
    CertificationLevel certificationLevel; // Certification level
}
```

#### 🔬 Agricultural Processes
- **FarmingProcess** - Planting and growing information
- **Medicine** - Plant protection products usage
- **Fertilizer** - Fertilizer application details
- **Harvest** - Harvesting information and quality
- **Distribution** - Distribution and storage conditions

### 🔐 Security Features

- **Role-based Access Control** - Owner, Admin, Verifier roles
- **Input Validation** - Comprehensive data validation
- **Modifiers** - Function access control
- **Events** - Complete audit trail

## 🔧 Development

### 🧪 Testing

```bash
# Run all tests
npx hardhat test

# Run specific test
npx hardhat test src/test/AgriculturalTraceabilityTest.js

# Run with coverage
npx hardhat coverage
```

### 📊 Gas Analysis

```bash
# Analyze gas usage
npx hardhat test --gas-reporter
```

### 🔍 Contract Verification

```bash
# Verify on ZeroScan
npx hardhat verify --network zeroscan 0x8F6c1F3bb7561988ef6F749874690aA2450b039E
```

## 📚 Documentation

### 📖 Available Guides

- **[📋 Usage Guide](docs/USAGE_GUIDE.md)** - How to use the contract
- **[🚀 Frontend Integration Guide](frontend/FRONTEND_INTEGRATION_GUIDE.md)** - Complete frontend integration
- **[✅ Integration Checklist](frontend/INTEGRATION_CHECKLIST.md)** - Step-by-step implementation
- **[⚡ Quick Start](frontend/QUICK_START.md)** - 5-minute setup guide

### 🔗 API Reference

The contract provides 44+ functions organized into categories:

#### 🏡 Farm Management
- `registerFarm()` - Register new farm
- `updateFarm()` - Update farm information
- `getFarm()` - Get farm details
- `getAllFarms()` - Get all farms
- `getFarmsByUserId()` - Get user's farms

#### 🌾 Product Management
- `addProduct()` - Add new product
- `updateProduct()` - Update product information
- `getProduct()` - Get product details
- `getProductsByFarm()` - Get farm's products
- `getCompleteProductTraceability()` - Get complete traceability

#### 🔬 Process Management
- `addFarmingProcess()` - Add farming process
- `addMedicine()` - Add medicine usage
- `addFertilizer()` - Add fertilizer usage
- `addHarvest()` - Add harvest information
- `addDistribution()` - Add distribution info

## 🎨 Frontend Integration

### 📦 Ready-to-Use Packages

The `frontend/` directory contains everything needed for web integration:

- **React Hooks** - Pre-built hooks for all contract functions
- **API Wrapper** - Easy-to-use JavaScript API
- **Configuration** - Network and contract settings
- **Documentation** - Complete integration guides

### 🚀 Quick Frontend Setup

```javascript
import { TraceabilityProvider, useWallet, useFarms } from './frontend/react-hooks.js';

function App() {
  return (
    <TraceabilityProvider>
      <YourComponents />
    </TraceabilityProvider>
  );
}

function FarmComponent() {
  const { connectWallet, isConnected } = useWallet();
  const { farms, registerFarm } = useFarms();
  
  // Your component logic here
}
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Technical Issues**: Check contract on [ZeroScan Explorer](https://zeroscan.org/address/0x8F6c1F3bb7561988ef6F749874690aA2450b039E#code)
- **Documentation**: See `docs/` and `frontend/` directories
- **Integration Help**: Follow the guides in `frontend/`

---

<div align="center">

### 🌾 **Built with ❤️ for Sustainable Agriculture**

**Empowering transparency in the food supply chain through blockchain technology**

</div>
