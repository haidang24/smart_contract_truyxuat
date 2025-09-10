# 🌾 Agricultural Traceability System v2.0

<div align="center">

![Solidity](https://img.shields.io/badge/Solidity-0.8.28-363636?style=for-the-badge&logo=solidity)
![Network](https://img.shields.io/badge/Network-ZeroScan-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-VERIFIED-brightgreen?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

**Blockchain-based Farm-to-Consumer Traceability System**

[Contract Address](#-contract-details) • [Quick Start](#-quick-start) • [Documentation](#-documentation)

</div>

---

## 🎯 Overview

A professional, modular smart contract system for end-to-end agricultural product traceability on blockchain. Track products from farm to consumer with complete transparency and immutable records.

### ✨ Key Features

- 🔒 **Enterprise Security** - Input validation, access control, gas optimized
- 📊 **Modular Architecture** - Clean separation of concerns, easy to maintain
- 🌾 **Complete Traceability** - From seed to consumer, full supply chain tracking
- 🏷️ **Batch Management** - Product batches with QR codes and certification
- 📱 **API Ready** - Easy integration with web/mobile applications
- 🚀 **Production Ready** - Verified, deployed, and tested on blockchain

---

## 🏗️ Architecture

### **Modular Design:**
```
src/contracts/
├── AgriculturalTraceabilitySystem.sol    # Main contract
├── interfaces/                           # Clean API contracts
├── libraries/                            # Reusable components
├── storage/                              # Data management
└── modules/                              # Business logic
    ├── FarmManagement.sol                # Farm operations
    ├── ProductManagement.sol             # Product operations
    └── ProcessManagement.sol             # Process tracking
```

### **Core Modules:**
- **Farm Management** - Register and manage farms
- **Product Management** - Track products and batches
- **Process Management** - Record agricultural processes
- **Traceability** - Complete product history

---

## 🚀 Contract Details

### **Deployment Information:**
- **Contract Address:** `0x1eCf95Ad252675701B542143f962B8F2f7336C67`
- **Network:** Zeroscan (Chain ID: 5080)
- **Status:** ✅ **VERIFIED & DEPLOYED**
- **Explorer:** [View on Zeroscan](https://zeroscan.org/address/0x1eCf95Ad252675701B542143f962B8F2f7336C67#code)
- **Version:** 2.0.0 (Modular Architecture)

### **Contract Functions:**
```solidity
// Farm Management
registerFarm()     // Register new farms
updateFarm()       // Update farm information
getAllFarms()      // Get all registered farms

// Product Management  
addProduct()       // Add products with batch tracking
updateProduct()    // Update product details
getProductByFarmCode() // Get products by farm

// Process Tracking
addFarmingProcess() // Record farming activities
addMedicine()      // Track medicine usage
addFertilizer()    // Record fertilizer application
addHarvest()       // Log harvest information
addDistribution()  // Track distribution

// Traceability
getCompleteProductTraceability() // Full product history
```

---

## 🛠️ Quick Start

### **Prerequisites:**
```bash
node >= 16.0.0
npm >= 8.0.0
```

### **Installation:**
```bash
git clone <repository>
cd SmartContractTruyXuat
npm install
```

### **Compile & Deploy:**
```bash
# Compile contracts
npx hardhat compile

# Deploy to network
npx hardhat run src/scripts/deploy-modular.js --network <network>

# Verify contract
npx hardhat verify --network <network> <contract-address>
```

### **Basic Usage:**
```javascript
// Connect to contract
const contract = new ethers.Contract(
  "0x1eCf95Ad252675701B542143f962B8F2f7336C67",
  ABI,
  signer
);

// Register a farm
await contract.registerFarm(
  "FARM001",           // farmCode
  "Nguyen Van A",      // fullname
  "Trang trai rau sach", // nameFarm
  "USER001",           // userId
  "farmer@example.com", // email
  "0123456789",        // phone
  "Trang trai trong rau sach huu co", // description
  "Ha Noi, Viet Nam",  // location
  1000,                // area (m²)
  ["image1.jpg"]       // images
);

// Add a product
const productData = {
  farmCode: "FARM001",
  productCode: "PROD001",
  categoryName: "Rau cu",
  name: "Rau Cai Xanh",
  quantity: "100kg",
  price: "50000 VND/kg",
  description: "Rau cai xanh huu co",
  image: "product1.jpg",
  batchCode: "BATCH001",
  certification: "Organic",
  certificationLevel: 2 // ORGANIC
};
await contract.addProduct(productData);

// Get complete traceability
const traceability = await contract.getCompleteProductTraceability("PROD001");
```

---

## 📊 Business Applications

### **Target Markets:**
- 🌾 **Agricultural Cooperatives** - Farm-to-table traceability
- 🏪 **Retail Supply Chains** - Supply chain transparency
- 🏛️ **Government Compliance** - Food safety compliance
- 🌍 **Export Certification** - International certification
- 👥 **Consumer Verification** - Product authenticity

### **Use Cases:**
- **Food Safety** - Track contamination sources
- **Organic Certification** - Verify organic practices
- **Export Documentation** - Meet international standards
- **Consumer Trust** - Build brand transparency
- **Supply Chain Optimization** - Identify bottlenecks

### **Revenue Models:**
- **SaaS Subscription** - Monthly/yearly access fees
- **Transaction Fees** - Per-product registration
- **Enterprise Licensing** - Custom deployments
- **API Access** - Third-party integrations

---

## 📚 Documentation

- 📖 **[Usage Guide](USAGE_GUIDE.md)** - Detailed usage instructions
- 🏗️ **Architecture** - Modular design documentation
- 💼 **Business Plan** - Commercialization strategy
- 🔧 **API Reference** - Function documentation

---

## 🧪 Testing

### **Run Tests:**
```bash
# Run all tests
npx hardhat test

# Run specific test
npx hardhat test src/test/AgriculturalTraceabilityTest.js
```

### **Test Coverage:**
- ✅ Farm registration and management
- ✅ Product addition and tracking
- ✅ Agricultural process recording
- ✅ Complete traceability queries
- ✅ Error handling and validation

---

## 🔒 Security

### **Security Features:**
- Input validation for all functions
- Access control with modifiers
- Reentrancy protection
- Gas optimization
- Comprehensive error handling

### **Audit Status:**
- ✅ Code review completed
- ✅ Gas optimization verified
- ✅ Security best practices implemented
- 🔄 Formal security audit (planned)

---

## 🤝 Contributing

This is a production-ready commercial project. For business inquiries:

- 💰 **Investment opportunities**
- 🤝 **Strategic partnerships**
- 🛠️ **Custom implementations**
- 📈 **Licensing agreements**

---

## 📄 License

Proprietary - Commercial use requires license agreement.

---

## 📞 Contact

**Ready for commercialization discussions!**

- **Contract:** [0x1eCf95Ad252675701B542143f962B8F2f7336C67](https://zeroscan.org/address/0x1eCf95Ad252675701B542143f962B8F2f7336C67#code)
- **Network:** Zeroscan (Chain ID: 5080)
- **Status:** Production Ready ✅

---

<div align="center">

**🌾 From Farm to Consumer - Complete Transparency on Blockchain**

*Last Updated: September 10, 2025 • Version: 2.0.0*

</div>