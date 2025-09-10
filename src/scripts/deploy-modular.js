const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Deploying Modular Agricultural Traceability System...");
  
  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("📝 Deploying with account:", deployer.address);
  
  try {
    // Deploy the main contract (which includes all modules)
    const AgriculturalTraceabilitySystem = await ethers.getContractFactory("src/contracts/AgriculturalTraceabilitySystem.sol:AgriculturalTraceabilitySystem");
    const contract = await AgriculturalTraceabilitySystem.deploy();
    
    await contract.waitForDeployment();
    const contractAddress = await contract.getAddress();
    
    console.log("✅ AgriculturalTraceabilitySystem deployed to:", contractAddress);
    
    // Get contract info
    const contractInfo = await contract.getContractInfo();
    console.log("\n📊 Contract Information:");
    console.log("- Name:", contractInfo[0]);
    console.log("- Version:", contractInfo[1]);
    console.log("- Total Farms:", contractInfo[2].toString());
    console.log("- Total Products:", contractInfo[3].toString());
    console.log("- Owner:", contractInfo[4]);
    
    // Test basic functionality
    console.log("\n📝 Testing modular functionality...");
    
    // Test farm registration
    const farmTx = await contract.registerFarm(
      "FARM001",
      "Nguyen Van A", 
      "Trang trai rau sach",
      "USER001",
      "farmer@example.com",
      "0123456789",
      "Trang trai trong rau sach huu co",
      "Ha Noi, Viet Nam",
      1000,
      ["image1.jpg", "image2.jpg"]
    );
    await farmTx.wait();
    console.log("✅ Farm registered successfully!");
    
    // Test product addition
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
    
    const productTx = await contract.addProduct(productData);
    await productTx.wait();
    console.log("✅ Product added successfully!");
    
    // Test process addition
    const processTx = await contract.addFarmingProcess(
      "PROD001",
      "Canh tac huu co",
      "Giong cai xanh huu co",
      "2024-01-01",
      "2024-01-15"
    );
    await processTx.wait();
    console.log("✅ Farming process added successfully!");
    
    // Test complete traceability
    const traceability = await contract.getCompleteProductTraceability("PROD001");
    console.log("✅ Complete traceability retrieved:");
    console.log("- Product:", traceability[0].name);
    console.log("- Farming Process:", traceability[1].nameProcess);
    
    // Save deployment info
    const deploymentInfo = {
      contractAddress: contractAddress,
      deployer: deployer.address,
      network: await ethers.provider.getNetwork(),
      timestamp: new Date().toISOString(),
      version: contractInfo[1],
      modules: [
        "FarmManagement",
        "ProductManagement", 
        "ProcessManagement",
        "TraceabilityStorage"
      ]
    };
    
    const fs = require('fs');
    fs.writeFileSync(
      'deployment-info-modular.json',
      JSON.stringify(deploymentInfo, null, 2)
    );
    
    console.log("\n🎉 Modular deployment completed!");
    console.log("Contract address:", contractAddress);
    console.log("📄 Deployment info saved to: deployment-info-modular.json");
    
  } catch (error) {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
