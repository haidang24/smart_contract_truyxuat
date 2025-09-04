const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Deploying AgriculturalTraceabilitySystem contract...");

  // Deploy contract
  const AgriculturalTraceabilitySystem = await ethers.getContractFactory("AgriculturalTraceabilitySystem");
  const truyXuat = await AgriculturalTraceabilitySystem.deploy();
  await truyXuat.waitForDeployment();

  console.log("✅ AgriculturalTraceabilitySystem deployed to:", await truyXuat.getAddress());

  // Test: Register farm
  console.log("\n📝 Testing farm registration...");
  
  const farmCode = "FARM001";
  const fullname = "Nguyen Van A";
  const nameFarm = "Nong Trai Xanh";
  const userId = "USER001";
  const email = "nguyenvana@email.com";
  const phone = "0123456789";
  const description = "Nông trại chuyên canh tác rau sạch";
  const location = "Hanoi, Vietnam";
  const area = 1000;
  const images = [
    "https://example.com/farm1.jpg",
    "https://example.com/farm2.jpg"
  ];

  try {
    const tx1 = await truyXuat.registerFarm(
      farmCode, fullname, nameFarm, userId, email, phone,
      description, location, area, images
    );
    await tx1.wait();
    console.log("✅ Farm registered successfully!");
  } catch (error) {
    console.log("❌ Error:", error.message);
  }

  // Test: Add product
  console.log("\n🌾 Testing product addition...");
  
  const productData = {
    farmCode: farmCode,
    productCode: "PROD001",
    categoryName: "Rau Xanh",
    name: "Rau Cải Xanh",
    quantity: "100kg",
    price: "50000 VND/kg",
    description: "Rau cải xanh tươi ngon",
    image: "https://example.com/raucai.jpg",
    batchCode: "BATCH001",
    certification: "VietGAP",
    certificationLevel: 2 // CertificationLevel.ORGANIC
  };

  try {
    const tx2 = await truyXuat.addProduct(productData);
    await tx2.wait();
    console.log("✅ Product added successfully!");
  } catch (error) {
    console.log("❌ Error:", error.message);
  }

  // Test: Add category
  console.log("\n📊 Testing category addition...");
  
  try {
    await truyXuat.addCategory("Rau Xanh", userId);
    await truyXuat.addCategory("Trái Cây", userId);
    console.log("✅ Categories added successfully!");
  } catch (error) {
    console.log("❌ Error:", error.message);
  }

  // Test: Add farm image
  console.log("\n🖼️ Testing farm image addition...");
  
  try {
    await truyXuat.addFarmImage(farmCode, "https://example.com/farm3.jpg");
    console.log("✅ Farm image added successfully!");
  } catch (error) {
    console.log("❌ Error:", error.message);
  }

  // Test: Add agricultural processes
  console.log("\n🌱 Testing agricultural processes...");
  
  const productCode = "PROD001";
  
  try {
    // Add farming process
    await truyXuat.addFarmingProcess(
      productCode,
      "Canh tác hữu cơ",
      "Hạt giống Việt Nam",
      "2024-01-15",
      "2024-01-10"
    );
    console.log("✅ Farming process added successfully!");

    // Add medicine
    await truyXuat.addMedicine(
      productCode,
      "Thuốc trừ sâu sinh học",
      "50ml",
      "2024-01-20",
      "Sinh học",
      "Phun"
    );
    console.log("✅ Medicine information added successfully!");

    // Add fertilizer
    await truyXuat.addFertilizer(
      productCode,
      "Phân hữu cơ",
      "10kg",
      "2024-01-10",
      "Phân chuồng",
      "Rải",
      "Tăng độ màu mỡ đất"
    );
    console.log("✅ Fertilizer information added successfully!");

    // Add harvest
    await truyXuat.addHarvest(
      productCode,
      "2024-03-15",
      "100kg",
      "95kg",
      "Tốt",
      "Thu hoạch thủ công"
    );
    console.log("✅ Harvest information added successfully!");

    // Add distribution
    await truyXuat.addDistribution(
      productCode,
      "Công ty ABC",
      "Siêu thị XYZ",
      "2024-03-16",
      "Xe tải lạnh",
      "Nhiệt độ 2-8°C"
    );
    console.log("✅ Distribution information added successfully!");

  } catch (error) {
    console.log("❌ Error adding processes:", error.message);
  }

  // Display results
  console.log("\n📊 Contract Information:");
  console.log("Total Farms:", await truyXuat.getTotalFarms());
  console.log("Total Products:", await truyXuat.getTotalProducts());
  
  try {
    const allCategories = await truyXuat.GetAllCategories();
    console.log("All Categories:", allCategories);
    
    const farmImages = await truyXuat.getFarmImages(farmCode);
    console.log("Farm Images:", farmImages);
    
    // Test complete product traceability
    console.log("\n🔍 Testing complete product traceability...");
    const completeTraceability = await truyXuat.getCompleteProductTraceability(productCode);
    console.log("✅ Complete traceability retrieved:");
    console.log("- Product:", completeTraceability[0].name);
    console.log("- Farming Process:", completeTraceability[1].nameProcess);
    console.log("- Medicine:", completeTraceability[2].nameMedicine);
    console.log("- Fertilizer:", completeTraceability[3].nameFertilizer);
    console.log("- Harvest Quality:", completeTraceability[4].quality);
    console.log("- Distribution:", completeTraceability[5].distributorName);
    
  } catch (error) {
    console.log("❌ Error retrieving data:", error.message);
  }

  console.log("\n🎉 Deployment completed!");
  console.log("Contract address:", await truyXuat.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });