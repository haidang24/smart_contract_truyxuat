const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Agricultural Traceability System", function () {
  let AgriculturalTraceabilitySystem;
  let contract;
  let owner;
  let user1;
  let user2;
  let admin;

  // Test data
  const farmData = {
    farmCode: "FARM001",
    fullname: "Nguyễn Văn A",
    nameFarm: "Nông Trại Xanh",
    userId: "USER001",
    email: "nguyenvana@email.com",
    phone: "0123456789",
    description: "Trang trại chuyên canh tác rau sạch hữu cơ",
    location: "Hà Nội, Việt Nam",
    area: 5000,
    images: ["https://example.com/farm1.jpg", "https://example.com/farm2.jpg"]
  };

  const productData = {
    farmCode: "FARM001",
    productCode: "PROD001",
    categoryName: "Rau Xanh",
    name: "Rau Cải Xanh Hữu Cơ",
    quantity: "500kg",
    price: "45,000 VND/kg",
    description: "Rau cải xanh được trồng theo phương pháp hữu cơ",
    image: "https://example.com/raucai.jpg",
    batchCode: "BATCH20241201",
    certification: "VietGAP, Organic",
    certificationLevel: 2 // ORGANIC
  };

  beforeEach(async function () {
    [owner, user1, user2, admin] = await ethers.getSigners();
    
    AgriculturalTraceabilitySystem = await ethers.getContractFactory("AgriculturalTraceabilitySystem");
    contract = await AgriculturalTraceabilitySystem.deploy();
    await contract.waitForDeployment();
  });

  describe("Contract Deployment", function () {
    it("Should deploy successfully", async function () {
      expect(await contract.getAddress()).to.be.properAddress;
    });

    it("Should set the deployer as owner", async function () {
      expect(await contract.owner()).to.equal(owner.address);
    });

    it("Should set the deployer as admin", async function () {
      expect(await contract.admin()).to.equal(owner.address);
    });

    it("Should initialize counters to zero", async function () {
      expect(await contract.getTotalFarms()).to.equal(0);
      expect(await contract.getTotalProducts()).to.equal(0);
    });

    it("Should authorize deployer as initial user", async function () {
      expect(await contract.authorizedUsers(owner.address)).to.be.true;
      expect(await contract.farmOwners(owner.address)).to.be.true;
      expect(await contract.productVerifiers(owner.address)).to.be.true;
    });
  });

  describe("Access Control", function () {
    it("Should allow owner to authorize users", async function () {
      await contract.authorizeUser(user1.address);
      expect(await contract.authorizedUsers(user1.address)).to.be.true;
    });

    it("Should allow owner to deauthorize users", async function () {
      await contract.authorizeUser(user1.address);
      await contract.deauthorizeUser(user1.address);
      expect(await contract.authorizedUsers(user1.address)).to.be.false;
    });

    it("Should allow owner to set farm owner status", async function () {
      await contract.setFarmOwner(user1.address, true);
      expect(await contract.farmOwners(user1.address)).to.be.true;
    });

    it("Should allow owner to update admin", async function () {
      await contract.updateAdmin(user1.address);
      expect(await contract.admin()).to.equal(user1.address);
    });

    it("Should not allow non-owner to authorize users", async function () {
      await expect(
        contract.connect(user1).authorizeUser(user2.address)
      ).to.be.revertedWith("AccessControl: Only admin allowed");
    });
  });

  describe("Farm Management", function () {
    beforeEach(async function () {
      // Authorize user1 for testing
      await contract.authorizeUser(user1.address);
    });

    it("Should register a farm successfully", async function () {
      await expect(
        contract.connect(user1).registerFarm(
          farmData.farmCode,
          farmData.fullname,
          farmData.nameFarm,
          farmData.userId,
          farmData.email,
          farmData.phone,
          farmData.description,
          farmData.location,
          farmData.area,
          farmData.images
        )
      ).to.emit(contract, "FarmRegistered");

      expect(await contract.getTotalFarms()).to.equal(1);
    });

    it("Should get farm information correctly", async function () {
      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );

      const farm = await contract.getFarm(farmData.farmCode);
      expect(farm.farmCode).to.equal(farmData.farmCode);
      expect(farm.fullname).to.equal(farmData.fullname);
      expect(farm.nameFarm).to.equal(farmData.nameFarm);
      expect(farm.userId).to.equal(farmData.userId);
      expect(farm.area).to.equal(farmData.area);
      expect(farm.isActive).to.be.true;
    });

    it("Should not register farm with duplicate code", async function () {
      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );

      await expect(
        contract.connect(user1).registerFarm(
          farmData.farmCode,
          farmData.fullname,
          farmData.nameFarm,
          farmData.userId,
          farmData.email,
          farmData.phone,
          farmData.description,
          farmData.location,
          farmData.area,
          farmData.images
        )
      ).to.be.revertedWith("Validation: Farm already exists");
    });

    it("Should update farm information", async function () {
      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );

      const newName = "Nông Trại Mới";
      const newArea = 8000;
      
      await expect(
        contract.connect(user1).updateFarm(
          farmData.farmCode,
          newName,
          farmData.description,
          farmData.location,
          newArea,
          farmData.images
        )
      ).to.emit(contract, "FarmUpdated");

      const updatedFarm = await contract.getFarm(farmData.farmCode);
      expect(updatedFarm.nameFarm).to.equal(newName);
      expect(updatedFarm.area).to.equal(newArea);
    });

    it("Should deactivate farm", async function () {
      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );

      await contract.connect(user1).deactivateFarm(farmData.farmCode);
      
      const farm = await contract.getFarm(farmData.farmCode);
      expect(farm.isActive).to.be.false;
    });

    it("Should get farms by user ID", async function () {
      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );

      const userFarms = await contract.getFarmsByUserId(farmData.userId);
      expect(userFarms.length).to.equal(1);
      expect(userFarms[0].farmCode).to.equal(farmData.farmCode);
    });

    it("Should validate area constraints", async function () {
      await expect(
        contract.connect(user1).registerFarm(
          "FARM999",
          farmData.fullname,
          farmData.nameFarm,
          farmData.userId,
          farmData.email,
          farmData.phone,
          farmData.description,
          farmData.location,
          0, // Invalid area
          farmData.images
        )
      ).to.be.revertedWith("Validation: Invalid area");
    });
  });

  describe("Product Management", function () {
    beforeEach(async function () {
      await contract.authorizeUser(user1.address);
      
      // Register a farm first
      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );
    });

    it("Should add product successfully", async function () {
      await expect(
        contract.connect(user1).addProduct(productData)
      ).to.emit(contract, "ProductAdded");

      expect(await contract.getTotalProducts()).to.equal(1);
    });

    it("Should get product information correctly", async function () {
      await contract.connect(user1).addProduct(productData);

      const product = await contract.getProduct(productData.productCode);
      expect(product.farmCode).to.equal(productData.farmCode);
      expect(product.productCode).to.equal(productData.productCode);
      expect(product.name).to.equal(productData.name);
      expect(product.quantity).to.equal(productData.quantity);
      expect(product.status).to.equal(0); // ACTIVE
    });

    it("Should not add product to non-existent farm", async function () {
      const invalidProductData = { ...productData, farmCode: "NONEXISTENT" };
      
      await expect(
        contract.connect(user1).addProduct(invalidProductData)
      ).to.be.revertedWith("Farm not found");
    });

    it("Should update product information", async function () {
      await contract.connect(user1).addProduct(productData);

      const newName = "Rau Cải Xanh Premium";
      const newPrice = "55,000 VND/kg";
      
      await expect(
        contract.connect(user1).updateProduct(
          productData.productCode,
          newName,
          productData.quantity,
          newPrice,
          productData.description,
          productData.image,
          productData.batchCode,
          productData.certification
        )
      ).to.emit(contract, "ProductUpdated");

      const updatedProduct = await contract.getProduct(productData.productCode);
      expect(updatedProduct.name).to.equal(newName);
      expect(updatedProduct.price).to.equal(newPrice);
    });

    it("Should deactivate product", async function () {
      await contract.connect(user1).addProduct(productData);

      await expect(
        contract.connect(user1).deactivateProduct(productData.productCode)
      ).to.emit(contract, "ProductStatusChanged");

      const product = await contract.getProduct(productData.productCode);
      expect(product.status).to.equal(1); // INACTIVE
    });

    it("Should get products by farm", async function () {
      await contract.connect(user1).addProduct(productData);

      const farmProducts = await contract.getProductsByFarm(farmData.farmCode);
      expect(farmProducts.length).to.equal(1);
      expect(farmProducts[0].productCode).to.equal(productData.productCode);
    });
  });

  describe("Agricultural Processes", function () {
    beforeEach(async function () {
      await contract.authorizeUser(user1.address);
      
      // Register farm and add product
      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );

      await contract.connect(user1).addProduct(productData);
    });

    it("Should add farming process", async function () {
      await expect(
        contract.connect(user1).addFarmingProcess(
          productData.productCode,
          "Canh tác hữu cơ",
          "Hạt giống F1 từ Nhật Bản",
          "2024-01-15",
          "2024-01-10"
        )
      ).to.emit(contract, "FarmingProcessAdded");

      const process = await contract.getFarmingProcess(productData.productCode);
      expect(process.nameProcess).to.equal("Canh tác hữu cơ");
      expect(process.source).to.equal("Hạt giống F1 từ Nhật Bản");
    });

    it("Should add medicine information", async function () {
      await expect(
        contract.connect(user1).addMedicine(
          productData.productCode,
          "Thuốc trừ sâu sinh học BT",
          "100ml",
          "2024-02-01",
          "Sinh học",
          "Phun sương"
        )
      ).to.emit(contract, "MedicineAdded");

      const medicine = await contract.getMedicine(productData.productCode);
      expect(medicine.nameMedicine).to.equal("Thuốc trừ sâu sinh học BT");
      expect(medicine.medicineType).to.equal("Sinh học");
    });

    it("Should add fertilizer information", async function () {
      await expect(
        contract.connect(user1).addFertilizer(
          productData.productCode,
          "Phân hữu cơ vi sinh",
          "50kg",
          "2024-01-20",
          "Hữu cơ",
          "Rải đều",
          "Cải thiện cấu trúc đất"
        )
      ).to.emit(contract, "FertilizerAdded");

      const fertilizer = await contract.getFertilizer(productData.productCode);
      expect(fertilizer.nameFertilizer).to.equal("Phân hữu cơ vi sinh");
      expect(fertilizer.fertilizerType).to.equal("Hữu cơ");
    });

    it("Should add harvest information", async function () {
      await expect(
        contract.connect(user1).addHarvest(
          productData.productCode,
          "2024-03-15",
          "500kg",
          "485kg",
          "Xuất sắc",
          "Thu hoạch thủ công"
        )
      ).to.emit(contract, "HarvestAdded");

      const harvest = await contract.getHarvest(productData.productCode);
      expect(harvest.estimatedQuantity).to.equal("500kg");
      expect(harvest.actualQuantity).to.equal("485kg");
      expect(harvest.quality).to.equal("Xuất sắc");
    });

    it("Should add distribution information", async function () {
      await expect(
        contract.connect(user1).addDistribution(
          productData.productCode,
          "Công ty TNHH Thực Phẩm Sạch ABC",
          "Hệ thống siêu thị BigC",
          "2024-03-16",
          "Xe tải lạnh",
          "Nhiệt độ 2-8°C, độ ẩm 85-90%"
        )
      ).to.emit(contract, "DistributionAdded");

      const distribution = await contract.getDistribution(productData.productCode);
      expect(distribution.distributorName).to.equal("Công ty TNHH Thực Phẩm Sạch ABC");
      expect(distribution.transportMethod).to.equal("Xe tải lạnh");
    });

    it("Should get complete product traceability", async function () {
      // Add all processes
      await contract.connect(user1).addFarmingProcess(
        productData.productCode,
        "Canh tác hữu cơ",
        "Hạt giống F1 từ Nhật Bản",
        "2024-01-15",
        "2024-01-10"
      );

      await contract.connect(user1).addMedicine(
        productData.productCode,
        "Thuốc trừ sâu sinh học BT",
        "100ml",
        "2024-02-01",
        "Sinh học",
        "Phun sương"
      );

      await contract.connect(user1).addFertilizer(
        productData.productCode,
        "Phân hữu cơ vi sinh",
        "50kg",
        "2024-01-20",
        "Hữu cơ",
        "Rải đều",
        "Cải thiện cấu trúc đất"
      );

      await contract.connect(user1).addHarvest(
        productData.productCode,
        "2024-03-15",
        "500kg",
        "485kg",
        "Xuất sắc",
        "Thu hoạch thủ công"
      );

      await contract.connect(user1).addDistribution(
        productData.productCode,
        "Công ty TNHH Thực Phẩm Sạch ABC",
        "Hệ thống siêu thị BigC",
        "2024-03-16",
        "Xe tải lạnh",
        "Nhiệt độ 2-8°C"
      );

      const traceability = await contract.getCompleteProductTraceability(productData.productCode);
      
      expect(traceability[0].name).to.equal(productData.name); // Product
      expect(traceability[1].nameProcess).to.equal("Canh tác hữu cơ"); // FarmingProcess
      expect(traceability[2].nameMedicine).to.equal("Thuốc trừ sâu sinh học BT"); // Medicine
      expect(traceability[3].nameFertilizer).to.equal("Phân hữu cơ vi sinh"); // Fertilizer
      expect(traceability[4].quality).to.equal("Xuất sắc"); // Harvest
      expect(traceability[5].distributorName).to.equal("Công ty TNHH Thực Phẩm Sạch ABC"); // Distribution
    });

    it("Should update farming process", async function () {
      await contract.connect(user1).addFarmingProcess(
        productData.productCode,
        "Canh tác hữu cơ",
        "Hạt giống F1 từ Nhật Bản",
        "2024-01-15",
        "2024-01-10"
      );

      await expect(
        contract.connect(user1).updateFarmingProcess(
          productData.productCode,
          "Canh tác hữu cơ nâng cao",
          "Hạt giống F1 từ Hàn Quốc",
          "2024-01-16",
          "2024-01-11"
        )
      ).to.emit(contract, "FarmingProcessUpdated");

      const process = await contract.getFarmingProcess(productData.productCode);
      expect(process.nameProcess).to.equal("Canh tác hữu cơ nâng cao");
      expect(process.source).to.equal("Hạt giống F1 từ Hàn Quốc");
    });
  });

  describe("Category Management", function () {
    it("Should add category successfully", async function () {
      await expect(
        contract.connect(user1).addCategory("Rau Xanh", "USER001")
      ).to.emit(contract, "CategoryAdded");

      const categories = await contract.GetAllCategories();
      expect(categories.length).to.equal(1);
      expect(categories[0]).to.equal("Rau Xanh");
    });

    it("Should get categories by user ID", async function () {
      await contract.connect(user1).addCategory("Rau Xanh", "USER001");
      await contract.connect(user1).addCategory("Trái Cây", "USER001");

      const userCategories = await contract.GetAllCategoryuserId("USER001");
      expect(userCategories.length).to.equal(2);
      expect(userCategories[0]).to.equal("Rau Xanh");
      expect(userCategories[1]).to.equal("Trái Cây");
    });

    it("Should check category existence", async function () {
      await contract.connect(user1).addCategory("Rau Xanh", "USER001");
      
      expect(await contract.categoryExistsCheck("Rau Xanh")).to.be.true;
      expect(await contract.categoryExistsCheck("Không Tồn Tại")).to.be.false;
    });
  });

  describe("Image Management", function () {
    beforeEach(async function () {
      await contract.authorizeUser(user1.address);
      
      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );
    });

    it("Should add farm image", async function () {
      const newImage = "https://example.com/farm3.jpg";
      
      await contract.connect(user1).addFarmImage(farmData.farmCode, newImage);
      
      const images = await contract.getFarmImages(farmData.farmCode);
      expect(images.length).to.equal(3);
      expect(images[2]).to.equal(newImage);
    });

    it("Should remove farm image", async function () {
      await contract.connect(user1).removeFarmImage(farmData.farmCode, 0);
      
      const images = await contract.getFarmImages(farmData.farmCode);
      expect(images.length).to.equal(1);
      expect(images[0]).to.equal(farmData.images[1]);
    });

    it("Should get farm images", async function () {
      const images = await contract.getFarmImages(farmData.farmCode);
      expect(images.length).to.equal(2);
      expect(images[0]).to.equal(farmData.images[0]);
      expect(images[1]).to.equal(farmData.images[1]);
    });
  });

  describe("Utility Functions", function () {
    beforeEach(async function () {
      await contract.authorizeUser(user1.address);
    });

    it("Should check user existence", async function () {
      expect(await contract.userExists("NONEXISTENT")).to.be.false;
      
      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );
      
      expect(await contract.userExists(farmData.userId)).to.be.true;
    });

    it("Should get all farms", async function () {
      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );

      const allFarms = await contract.getAllFarms();
      expect(allFarms.length).to.equal(1);
      expect(allFarms[0].farmCode).to.equal(farmData.farmCode);
    });

    it("Should get correct totals", async function () {
      expect(await contract.getTotalFarms()).to.equal(0);
      expect(await contract.getTotalProducts()).to.equal(0);

      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );

      expect(await contract.getTotalFarms()).to.equal(1);

      await contract.connect(user1).addProduct(productData);
      expect(await contract.getTotalProducts()).to.equal(1);
    });
  });

  describe("Error Handling", function () {
    it("Should revert when accessing non-existent farm", async function () {
      await expect(
        contract.getFarm("NONEXISTENT")
      ).to.be.revertedWith("FarmManagement: Farm not found");
    });

    it("Should revert when accessing non-existent product", async function () {
      await expect(
        contract.getProduct("NONEXISTENT")
      ).to.be.revertedWith("ProductManagement: Product not found");
    });

    it("Should revert when unauthorized user tries to register farm", async function () {
      await expect(
        contract.connect(user2).registerFarm(
          farmData.farmCode,
          farmData.fullname,
          farmData.nameFarm,
          farmData.userId,
          farmData.email,
          farmData.phone,
          farmData.description,
          farmData.location,
          farmData.area,
          farmData.images
        )
      ).to.be.revertedWith("AccessControl: Not authorized");
    });

    it("Should validate empty inputs", async function () {
      await contract.authorizeUser(user1.address);
      
      await expect(
        contract.connect(user1).registerFarm(
          "", // Empty farmCode
          farmData.fullname,
          farmData.nameFarm,
          farmData.userId,
          farmData.email,
          farmData.phone,
          farmData.description,
          farmData.location,
          farmData.area,
          farmData.images
        )
      ).to.be.revertedWith("Validation: Empty farmCode");
    });
  });

  describe("Integration Test", function () {
    it("Should perform complete workflow successfully", async function () {
      // Step 1: Authorize user
      await contract.authorizeUser(user1.address);
      
      // Step 2: Register farm
      await contract.connect(user1).registerFarm(
        farmData.farmCode,
        farmData.fullname,
        farmData.nameFarm,
        farmData.userId,
        farmData.email,
        farmData.phone,
        farmData.description,
        farmData.location,
        farmData.area,
        farmData.images
      );
      
      // Step 3: Add product
      await contract.connect(user1).addProduct(productData);
      
      // Step 4: Add category
      await contract.connect(user1).addCategory("Rau Xanh", farmData.userId);
      
      // Step 5: Add all agricultural processes
      await contract.connect(user1).addFarmingProcess(
        productData.productCode,
        "Canh tác hữu cơ",
        "Hạt giống F1",
        "2024-01-15",
        "2024-01-10"
      );
      
      await contract.connect(user1).addMedicine(
        productData.productCode,
        "Thuốc sinh học",
        "100ml",
        "2024-02-01",
        "Sinh học",
        "Phun"
      );
      
      await contract.connect(user1).addFertilizer(
        productData.productCode,
        "Phân hữu cơ",
        "50kg",
        "2024-01-20",
        "Hữu cơ",
        "Rải",
        "Tăng độ màu mỡ"
      );
      
      await contract.connect(user1).addHarvest(
        productData.productCode,
        "2024-03-15",
        "500kg",
        "485kg",
        "Tốt",
        "Thủ công"
      );
      
      await contract.connect(user1).addDistribution(
        productData.productCode,
        "Công ty ABC",
        "Siêu thị XYZ",
        "2024-03-16",
        "Xe lạnh",
        "2-8°C"
      );
      
      // Step 6: Verify complete traceability
      const traceability = await contract.getCompleteProductTraceability(productData.productCode);
      
      expect(traceability[0].name).to.equal(productData.name);
      expect(traceability[1].nameProcess).to.equal("Canh tác hữu cơ");
      expect(traceability[2].nameMedicine).to.equal("Thuốc sinh học");
      expect(traceability[3].nameFertilizer).to.equal("Phân hữu cơ");
      expect(traceability[4].quality).to.equal("Tốt");
      expect(traceability[5].distributorName).to.equal("Công ty ABC");
      
      // Step 7: Verify totals
      expect(await contract.getTotalFarms()).to.equal(1);
      expect(await contract.getTotalProducts()).to.equal(1);
      expect(await contract.userExists(farmData.userId)).to.be.true;
      
      // Step 8: Verify categories
      const categories = await contract.GetAllCategories();
      expect(categories.length).to.equal(1);
      expect(categories[0]).to.equal("Rau Xanh");
    });
  });
});
