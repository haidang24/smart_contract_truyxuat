# 📖 Usage Guide - Agricultural Traceability System

## 🎯 Overview

This guide provides detailed instructions for using the Agricultural Traceability System smart contract. Learn how to register farms, add products, track processes, and retrieve complete traceability information.

---

## 🚀 Getting Started

### **Prerequisites**
- Node.js >= 16.0.0
- npm >= 8.0.0
- Basic knowledge of Ethereum/blockchain
- Web3 wallet (MetaMask, etc.)

### **Contract Information**
- **Address:** `0x1eCf95Ad252675701B542143f962B8F2f7336C67`
- **Network:** Zeroscan (Chain ID: 5080)
- **ABI:** Available in build artifacts

---

## 🏗️ Setup & Installation

### **1. Install Dependencies**
```bash
npm install
```

### **2. Compile Contracts**
```bash
npx hardhat compile
```

### **3. Connect to Contract**
```javascript
const { ethers } = require("hardhat");

// Get contract instance
const contractAddress = "0x1eCf95Ad252675701B542143f962B8F2f7336C67";
const contract = await ethers.getContractAt("AgriculturalTraceabilitySystem", contractAddress);
```

---

## 🌾 Farm Management

### **Register a New Farm**

```javascript
async function registerFarm() {
  const tx = await contract.registerFarm(
    "FARM001",                    // farmCode (unique identifier)
    "Nguyen Van A",               // fullname (farmer's full name)
    "Trang trai rau sach",        // nameFarm (farm name)
    "USER001",                    // userId (user identifier)
    "farmer@example.com",         // email
    "0123456789",                 // phone
    "Trang trai trong rau sach huu co", // description
    "Ha Noi, Viet Nam",           // location
    1000,                         // area (in square meters)
    ["farm1.jpg", "farm2.jpg"]    // images array
  );
  
  await tx.wait();
  console.log("Farm registered successfully!");
}
```

**Parameters:**
- `farmCode`: Unique identifier for the farm (string)
- `fullname`: Full name of the farmer (string)
- `nameFarm`: Name of the farm (string)
- `userId`: User identifier (string)
- `email`: Contact email (string)
- `phone`: Contact phone (string)
- `description`: Farm description (string)
- `location`: Farm location (string)
- `area`: Farm area in square meters (uint256, 1-1,000,000)
- `images`: Array of image URLs (string[], max 10)

### **Update Farm Information**

```javascript
async function updateFarm() {
  const tx = await contract.updateFarm(
    "FARM001",                    // farmCode
    "Trang trai rau sach moi",    // new nameFarm (optional)
    "Trang trai huu co chuyen nghiep", // new description (optional)
    "Ha Noi, Viet Nam - Updated", // new location (optional)
    1200,                         // new area (optional)
    ["new1.jpg", "new2.jpg"]      // new images (optional)
  );
  
  await tx.wait();
  console.log("Farm updated successfully!");
}
```

### **Get Farm Information**

```javascript
async function getFarm() {
  const farm = await contract.getFarm("FARM001");
  console.log("Farm Details:", {
    farmCode: farm.farmCode,
    fullname: farm.fullname,
    nameFarm: farm.nameFarm,
    location: farm.location,
    area: farm.area.toString(),
    isActive: farm.isActive
  });
}

async function getAllFarms() {
  const farms = await contract.getAllFarms();
  console.log(`Total farms: ${farms.length}`);
  farms.forEach((farm, index) => {
    console.log(`Farm ${index + 1}: ${farm.nameFarm} (${farm.farmCode})`);
  });
}
```

---

## 🥬 Product Management

### **Add a New Product**

```javascript
async function addProduct() {
  const productData = {
    farmCode: "FARM001",              // Farm where product is grown
    productCode: "PROD001",           // Unique product identifier
    categoryName: "Rau cu",           // Product category
    name: "Rau Cai Xanh",             // Product name
    quantity: "100kg",                // Product quantity
    price: "50000 VND/kg",            // Product price
    description: "Rau cai xanh huu co", // Product description
    image: "product1.jpg",            // Product image URL
    batchCode: "BATCH001",            // Batch identifier
    certification: "Organic",         // Certification type
    certificationLevel: 2             // 0=NONE, 1=BASIC, 2=ORGANIC, 3=PREMIUM, 4=CERTIFIED
  };
  
  const tx = await contract.addProduct(productData);
  await tx.wait();
  console.log("Product added successfully!");
}
```

**Certification Levels:**
- `0` - NONE
- `1` - BASIC
- `2` - ORGANIC
- `3` - PREMIUM
- `4` - CERTIFIED

### **Update Product Information**

```javascript
async function updateProduct() {
  const tx = await contract.updateProduct(
    "PROD001",                    // productCode
    "Rau Cai Xanh Premium",       // new name (optional)
    "150kg",                      // new quantity (optional)
    "60000 VND/kg",               // new price (optional)
    "Rau cai xanh huu co premium", // new description (optional)
    "product1_new.jpg",           // new image (optional)
    "BATCH001_V2",                // new batchCode (optional)
    "Organic Premium"             // new certification (optional)
  );
  
  await tx.wait();
  console.log("Product updated successfully!");
}
```

### **Get Product Information**

```javascript
async function getProduct() {
  const product = await contract.getProduct("PROD001");
  console.log("Product Details:", {
    productCode: product.productCode,
    name: product.name,
    categoryName: product.categoryName,
    quantity: product.quantity,
    price: product.price,
    status: product.status,
    certificationLevel: product.certificationLevel
  });
}

async function getProductsByFarm() {
  const products = await contract.getProductByFarmCode("FARM001");
  console.log(`Products from FARM001: ${products.length}`);
  products.forEach((product, index) => {
    console.log(`Product ${index + 1}: ${product.name} (${product.productCode})`);
  });
}
```

---

## 🌱 Agricultural Process Tracking

### **Add Farming Process**

```javascript
async function addFarmingProcess() {
  const tx = await contract.addFarmingProcess(
    "PROD001",                    // productCode
    "Canh tac huu co",            // nameProcess
    "Giong cai xanh huu co",      // source (seed source)
    "2024-01-01",                 // plantingDate
    "2024-01-15"                  // sowingDate
  );
  
  await tx.wait();
  console.log("Farming process added successfully!");
}
```

### **Add Medicine Information**

```javascript
async function addMedicine() {
  const tx = await contract.addMedicine(
    "PROD001",                    // productCode
    "Thuoc tru sau sinh hoc",     // nameMedicine
    "50ml",                       // quantityMedicine
    "2024-02-01",                 // medicineDate
    "Sinh hoc",                   // medicineType
    "Phun la"                     // applicationMethod
  );
  
  await tx.wait();
  console.log("Medicine information added successfully!");
}
```

### **Add Fertilizer Information**

```javascript
async function addFertilizer() {
  const tx = await contract.addFertilizer(
    "PROD001",                    // productCode
    "Phan huu co",                // nameFertilizer
    "10kg",                       // quantityFertilizer
    "2024-01-20",                 // fertilizerDate
    "Huu co",                     // fertilizerType
    "Bo goc",                     // applicationMethod
    "Tang do mau mo cho la"       // expectedEffect
  );
  
  await tx.wait();
  console.log("Fertilizer information added successfully!");
}
```

### **Add Harvest Information**

```javascript
async function addHarvest() {
  const tx = await contract.addHarvest(
    "PROD001",                    // productCode
    "2024-03-15",                 // harvestDate
    "120kg",                      // estimatedQuantity
    "115kg",                      // actualQuantity
    "Tot",                        // quality
    "Thu hoach bang tay"          // harvestMethod
  );
  
  await tx.wait();
  console.log("Harvest information added successfully!");
}
```

### **Add Distribution Information**

```javascript
async function addDistribution() {
  const tx = await contract.addDistribution(
    "PROD001",                    // productCode
    "Cong ty ABC",                // distributorName
    "Sieuthi XYZ",                // distributorPartner
    "2024-03-20",                 // distributionDate
    "Xe tai lanh",                // transportMethod
    "Nhiet do 2-4 do C"          // storageConditions
  );
  
  await tx.wait();
  console.log("Distribution information added successfully!");
}
```

---

## 🔍 Complete Traceability

### **Get Complete Product History**

```javascript
async function getCompleteTraceability() {
  const traceability = await contract.getCompleteProductTraceability("PROD001");
  
  const [product, farmingProcess, medicine, fertilizer, harvest, distribution] = traceability;
  
  console.log("=== COMPLETE PRODUCT TRACEABILITY ===");
  console.log("\n📦 PRODUCT INFORMATION:");
  console.log(`Name: ${product.name}`);
  console.log(`Category: ${product.categoryName}`);
  console.log(`Quantity: ${product.quantity}`);
  console.log(`Price: ${product.price}`);
  console.log(`Certification: ${product.certification}`);
  
  console.log("\n🌱 FARMING PROCESS:");
  console.log(`Process: ${farmingProcess.nameProcess}`);
  console.log(`Source: ${farmingProcess.source}`);
  console.log(`Planting Date: ${farmingProcess.plantingDate}`);
  console.log(`Sowing Date: ${farmingProcess.sowingDate}`);
  
  console.log("\n💊 MEDICINE USAGE:");
  console.log(`Medicine: ${medicine.nameMedicine}`);
  console.log(`Quantity: ${medicine.quantityMedicine}`);
  console.log(`Date: ${medicine.medicineDate}`);
  console.log(`Type: ${medicine.medicineType}`);
  
  console.log("\n🌿 FERTILIZER USAGE:");
  console.log(`Fertilizer: ${fertilizer.nameFertilizer}`);
  console.log(`Quantity: ${fertilizer.quantityFertilizer}`);
  console.log(`Date: ${fertilizer.fertilizerDate}`);
  console.log(`Type: ${fertilizer.fertilizerType}`);
  
  console.log("\n🌾 HARVEST INFORMATION:");
  console.log(`Harvest Date: ${harvest.harvestDate}`);
  console.log(`Estimated: ${harvest.estimatedQuantity}`);
  console.log(`Actual: ${harvest.actualQuantity}`);
  console.log(`Quality: ${harvest.quality}`);
  
  console.log("\n🚚 DISTRIBUTION:");
  console.log(`Distributor: ${distribution.distributorName}`);
  console.log(`Partner: ${distribution.distributorPartner}`);
  console.log(`Date: ${distribution.distributionDate}`);
  console.log(`Transport: ${distribution.transportMethod}`);
}
```

---

## ⚠️ Error Handling

### **Common Errors and Solutions**

```javascript
async function handleErrors() {
  try {
    // This will fail if farm doesn't exist
    await contract.getFarm("NONEXISTENT");
  } catch (error) {
    if (error.message.includes("!farm")) {
      console.log("Error: Farm does not exist");
    }
  }
  
  try {
    // This will fail if product already exists
    await contract.addProduct(duplicateProductData);
  } catch (error) {
    if (error.message.includes("exists")) {
      console.log("Error: Product already exists");
    }
  }
  
  try {
    // This will fail if area is invalid
    await contract.registerFarm(/* ... */, 0); // Invalid area
  } catch (error) {
    if (error.message.includes("!area")) {
      console.log("Error: Invalid area (must be 1-1,000,000)");
    }
  }
}
```

### **Error Codes Reference**
- `!farm` - Farm does not exist
- `!product` - Product does not exist
- `!active` - Farm/Product is inactive
- `exists` - Farm/Product already exists
- `!area` - Invalid area (must be 1-1,000,000)
- `!images` - Too many images (max 10)
- `!owner` - Not the contract owner

---

## 🧪 Testing Examples

### **Complete Workflow Test**

```javascript
async function completeWorkflowTest() {
  console.log("🚀 Starting complete workflow test...");
  
  // 1. Register farm
  console.log("1. Registering farm...");
  await registerFarm();
  
  // 2. Add product
  console.log("2. Adding product...");
  await addProduct();
  
  // 3. Add farming process
  console.log("3. Adding farming process...");
  await addFarmingProcess();
  
  // 4. Add medicine
  console.log("4. Adding medicine information...");
  await addMedicine();
  
  // 5. Add fertilizer
  console.log("5. Adding fertilizer information...");
  await addFertilizer();
  
  // 6. Add harvest
  console.log("6. Adding harvest information...");
  await addHarvest();
  
  // 7. Add distribution
  console.log("7. Adding distribution information...");
  await addDistribution();
  
  // 8. Get complete traceability
  console.log("8. Getting complete traceability...");
  await getCompleteTraceability();
  
  console.log("✅ Complete workflow test finished!");
}
```

---

## 📊 Best Practices

### **1. Data Validation**
- Always validate input data before sending transactions
- Check for required fields and proper formats
- Handle errors gracefully

### **2. Gas Optimization**
- Batch multiple operations when possible
- Use appropriate gas limits
- Monitor gas prices

### **3. Security**
- Never expose private keys
- Use environment variables for sensitive data
- Validate all user inputs

### **4. Error Handling**
- Implement comprehensive error handling
- Provide meaningful error messages
- Log important events

---

## 🔧 Advanced Usage

### **Event Listening**

```javascript
// Listen for farm registration events
contract.on("FarmRegistered", (farmCode, userId, owner, area, timestamp) => {
  console.log(`New farm registered: ${farmCode} by ${userId}`);
});

// Listen for product addition events
contract.on("ProductAdded", (farmCode, productCode, categoryName, status, timestamp) => {
  console.log(`New product added: ${productCode} in category ${categoryName}`);
});
```

### **Batch Operations**

```javascript
async function batchAddProducts() {
  const products = [
    { /* product 1 data */ },
    { /* product 2 data */ },
    { /* product 3 data */ }
  ];
  
  for (const product of products) {
    const tx = await contract.addProduct(product);
    await tx.wait();
    console.log(`Added product: ${product.productCode}`);
  }
}
```

---

## 📞 Support

For technical support or questions:
- Check the contract on [Zeroscan Explorer](https://zeroscan.org/address/0x1eCf95Ad252675701B542143f962B8F2f7336C67#code)
- Review the smart contract source code
- Test with the provided examples

---

**Happy tracking! 🌾📱**
