# 🌾 Agricultural Traceability System - Frontend Integration

## 📋 Contract Information

- **Network**: ZeroScan (Chain ID: 5080)
- **Contract Address**: `0x8F6c1F3bb7561988ef6F749874690aA2450b039E`
- **RPC URL**: `https://rpc.zeroscan.org`

## 🚀 Quick Setup

```javascript
import { ethers } from 'ethers';
import contractABI from './abi/AgriculturalTraceabilitySystem.json';

// Setup contract
const CONTRACT_ADDRESS = '0x8F6c1F3bb7561988ef6F749874690aA2450b039E';
const provider = new ethers.JsonRpcProvider('https://rpc.zeroscan.org');
const contract = new ethers.Contract(CONTRACT_ADDRESS, contractABI.abi, provider);

// Connect wallet
const browserProvider = new ethers.BrowserProvider(window.ethereum);
const signer = await browserProvider.getSigner();
const contractWithSigner = contract.connect(signer);
```

## 📊 Smart Contract Functions

### 🏡 Farm Management

#### Register Farm
```javascript
await contractWithSigner.registerFarm(
  "FARM001",              // farmCode
  "Nguyễn Văn A",         // fullname
  "Nông Trại Xanh",      // nameFarm
  "USER001",              // userId
  "email@example.com",    // email
  "0123456789",           // phone
  "Mô tả trang trại",     // description
  "Hà Nội, Việt Nam",     // location
  5000,                   // area (m²)
  ["https://img1.jpg"]    // images (max 10)
);
// Gas: ~540,000
```

#### Update Farm
```javascript
await contractWithSigner.updateFarm(
  "FARM001",              // farmCode
  "Tên mới",              // nameFarm
  "Mô tả mới",            // description
  "Vị trí mới",           // location
  6000,                   // area
  ["https://newimg.jpg"]  // images
);
// Gas: ~68,000
```

#### Get Farm
```javascript
const farm = await contract.getFarm("FARM001");
// Returns: Farm struct with all details
// Gas: FREE
```

#### Get All Farms
```javascript
const allFarms = await contract.getAllFarms();
// Returns: Array of all farms
// Gas: FREE
```

#### Get Farms by User
```javascript
const userFarms = await contract.getFarmsByUserId("USER001");
// Returns: Array of user's farms
// Gas: FREE
```

### 🌾 Product Management

#### Add Product
```javascript
const productData = {
  farmCode: "FARM001",
  productCode: "PROD001",
  categoryName: "Rau Xanh",
  name: "Rau Cải",
  quantity: "100kg",
  price: "50,000 VND/kg",
  description: "Rau cải tươi ngon",
  image: "https://product.jpg",
  batchCode: "BATCH001",
  certification: "VietGAP",
  certificationLevel: 2  // 0=NONE, 1=BASIC, 2=ORGANIC, 3=PREMIUM, 4=CERTIFIED
};

await contractWithSigner.addProduct(productData);
// Gas: ~495,000
```

#### Get Product
```javascript
const product = await contract.getProduct("PROD001");
// Returns: Product struct
// Gas: FREE
```

#### Get Products by Farm
```javascript
const farmProducts = await contract.getProductsByFarm("FARM001");
// Returns: Array of farm's products
// Gas: FREE
```

### 🔬 Agricultural Processes

#### Add Farming Process
```javascript
await contractWithSigner.addFarmingProcess(
  "PROD001",              // productCode
  "Canh tác hữu cơ",      // nameProcess
  "Hạt giống F1",         // source
  "2024-01-15",           // plantingDate
  "2024-01-10"            // sowingDate
);
// Gas: ~207,000
```

#### Add Medicine Usage
```javascript
await contractWithSigner.addMedicine(
  "PROD001",              // productCode
  "Thuốc trừ sâu BT",     // nameMedicine
  "100ml",                // quantityMedicine
  "2024-02-01",           // medicineDate
  "Sinh học",             // medicineType
  "Phun sương"            // applicationMethod
);
// Gas: ~212,000
```

#### Add Fertilizer Usage
```javascript
await contractWithSigner.addFertilizer(
  "PROD001",              // productCode
  "Phân hữu cơ",          // nameFertilizer
  "50kg",                 // quantityFertilizer
  "2024-01-20",           // fertilizerDate
  "Hữu cơ",               // fertilizerType
  "Rải đều",              // applicationMethod
  "Tăng độ màu mỡ đất"    // expectedEffect
);
// Gas: ~235,000
```

#### Add Harvest Info
```javascript
await contractWithSigner.addHarvest(
  "PROD001",              // productCode
  "2024-03-15",           // harvestDate
  "100kg",                // estimatedQuantity
  "95kg",                 // actualQuantity
  "Xuất sắc",             // quality
  "Thu hoạch thủ công"    // harvestMethod
);
// Gas: ~195,000
```

#### Add Distribution Info
```javascript
await contractWithSigner.addDistribution(
  "PROD001",              // productCode
  "Công ty ABC",          // distributorName
  "Siêu thị XYZ",         // distributorPartner
  "2024-03-16",           // distributionDate
  "Xe tải lạnh",          // transportMethod
  "2-8°C, 85-90% ẩm"      // storageConditions
);
// Gas: ~251,000
```

### 🔍 Complete Traceability

#### Get Full Product Traceability
```javascript
const traceability = await contract.getCompleteProductTraceability("PROD001");

// Returns array with:
// [0] = Product info
// [1] = FarmingProcess info
// [2] = Medicine info
// [3] = Fertilizer info
// [4] = Harvest info
// [5] = Distribution info

console.log("Product:", traceability[0].name);
console.log("Farming:", traceability[1].nameProcess);
console.log("Medicine:", traceability[2].nameMedicine);
console.log("Fertilizer:", traceability[3].nameFertilizer);
console.log("Harvest:", traceability[4].quality);
console.log("Distribution:", traceability[5].distributorName);
```

### 📊 Categories & Images

#### Add Category
```javascript
await contractWithSigner.addCategory("Rau Xanh", "USER001");
// Gas: ~134,000
```

#### Get All Categories
```javascript
const categories = await contract.GetAllCategories();
// Gas: FREE
```

#### Add Farm Image
```javascript
await contractWithSigner.addFarmImage("FARM001", "https://newimage.jpg");
// Gas: ~58,000
```

#### Remove Farm Image
```javascript
await contractWithSigner.removeFarmImage("FARM001", 0); // index 0
// Gas: ~41,000
```

### 📈 Statistics

#### Get Contract Stats
```javascript
const totalFarms = await contract.getTotalFarms();
const totalProducts = await contract.getTotalProducts();
// Gas: FREE
```

## 🔧 Error Handling

```javascript
try {
  await contractWithSigner.registerFarm(...params);
} catch (error) {
  if (error.message.includes('Farm already exists')) {
    console.log('Trang trại đã tồn tại');
  } else if (error.message.includes('Invalid area')) {
    console.log('Diện tích không hợp lệ (1-1,000,000 m²)');
  } else if (error.code === 4001) {
    console.log('Người dùng từ chối giao dịch');
  } else {
    console.log('Lỗi:', error.message);
  }
}
```

## 📱 MetaMask Network Setup

```javascript
// Add ZeroScan network
await window.ethereum.request({
  method: 'wallet_addEthereumChain',
  params: [{
    chainId: '0x13d0', // 5080 in hex
    chainName: 'ZeroScan',
    rpcUrls: ['https://rpc.zeroscan.org'],
    nativeCurrency: {
      name: 'ETH',
      symbol: 'ETH',
      decimals: 18,
    },
    blockExplorerUrls: ['https://zeroscan.org'],
  }],
});
```

## 🎯 Complete Example

```javascript
// 1. Setup
const provider = new ethers.BrowserProvider(window.ethereum);
const signer = await provider.getSigner();
const contract = new ethers.Contract(CONTRACT_ADDRESS, contractABI.abi, signer);

// 2. Register farm
await contract.registerFarm("FARM001", "Farmer Name", "Farm Name", "USER001", 
  "email@test.com", "0123456789", "Description", "Location", 5000, []);

// 3. Add product
const productData = {
  farmCode: "FARM001", productCode: "PROD001", categoryName: "Vegetables",
  name: "Lettuce", quantity: "100kg", price: "50000", description: "Fresh lettuce",
  image: "", batchCode: "BATCH001", certification: "Organic", certificationLevel: 2
};
await contract.addProduct(productData);

// 4. Add processes
await contract.addFarmingProcess("PROD001", "Organic farming", "Premium seeds", "2024-01-15", "2024-01-10");
await contract.addHarvest("PROD001", "2024-03-15", "100kg", "95kg", "Excellent", "Hand-picked");

// 5. Get complete traceability
const traceability = await contract.getCompleteProductTraceability("PROD001");
console.log("Complete traceability:", traceability);
```

---

**Contract Explorer**: https://zeroscan.org/address/0x8F6c1F3bb7561988ef6F749874690aA2450b039E#code
