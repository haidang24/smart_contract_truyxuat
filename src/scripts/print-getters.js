const { ethers } = require("hardhat");
const fs = require("fs");

async function main() {
  console.log("🔎 Printing all getter outputs...\n");

  // Load deployment info
  const dep = JSON.parse(fs.readFileSync("deployment-info-modular.json", "utf8"));
  const address = dep.contractAddress;
  if (!address) {
    throw new Error("No contractAddress in deployment-info-modular.json");
  }

  const Contract = await ethers.getContractFactory(
    "src/contracts/AgriculturalTraceabilitySystem.sol:AgriculturalTraceabilitySystem"
  );
  const provider = ethers.provider;
  const [signer] = await ethers.getSigners();
  const contract = new ethers.Contract(address, (await Contract.interface).format(), signer || provider);

  // Helper to pretty print arrays of structs
  const printArray = (label, arr) => {
    console.log(`\n${label} (count=${arr.length})`);
    arr.forEach((item, idx) => {
      console.log(`- [${idx}]`, item);
    });
  };

  // 1) getContractInfo
  try {
    const info = await contract.getContractInfo();
    console.log("\n=== getContractInfo ===");
    console.log("name:", info[0]);
    console.log("version:", info[1]);
    console.log("totalFarms:", info[2].toString());
    console.log("totalProducts:", info[3].toString());
    console.log("owner:", info[4]);
  } catch (e) {
    console.log("getContractInfo error:", e.message);
  }

  // The following getters require parameters or data to exist. We'll attempt with some common samples
  // You can modify sample codes below according to your dataset
  const sampleUserId = "USER001";
  const sampleFarmCode = "FARM001";
  const sampleProductCode = "PROD001";

  // 2) getAllFarms
  try {
    console.log("\n=== getAllFarms ===");
    const farms = await contract.getAllFarms();
    printArray("Farms", farms);
  } catch (e) {
    console.log("getAllFarms error:", e.message);
  }

  // 3) getFarmByUserId(userId)
  try {
    console.log("\n=== getFarmByUserId ===");
    const farmsByUser = await contract.getFarmByUserId(sampleUserId);
    printArray(`Farms of ${sampleUserId}`, farmsByUser);
  } catch (e) {
    console.log("getFarmByUserId error:", e.message);
  }

  // 4) getFarm(farmCode)
  try {
    console.log("\n=== getFarm ===");
    const farm = await contract.getFarm(sampleFarmCode);
    console.log("Farm:", farm);
  } catch (e) {
    console.log("getFarm error:", e.message);
  }

  // 5) getProduct(productCode)
  try {
    console.log("\n=== getProduct ===");
    const product = await contract.getProduct(sampleProductCode);
    console.log("Product:", product);
  } catch (e) {
    console.log("getProduct error:", e.message);
  }

  // 6) getProductByFarmCode(farmCode)
  try {
    console.log("\n=== getProductByFarmCode ===");
    const productsByFarm = await contract.getProductByFarmCode(sampleFarmCode);
    printArray(`Products of ${sampleFarmCode}`, productsByFarm);
  } catch (e) {
    console.log("getProductByFarmCode error:", e.message);
  }

  // 7) getCompleteProductTraceability(productCode)
  try {
    console.log("\n=== getCompleteProductTraceability ===");
    const trace = await contract.getCompleteProductTraceability(sampleProductCode);
    const [product, farmingProcess, medicine, fertilizer, harvest, distribution] = trace;
    console.log("Product:", product);
    console.log("FarmingProcess:", farmingProcess);
    console.log("Medicine:", medicine);
    console.log("Fertilizer:", fertilizer);
    console.log("Harvest:", harvest);
    console.log("Distribution:", distribution);
  } catch (e) {
    console.log("getCompleteProductTraceability error:", e.message);
  }

  console.log("\n✅ Done printing all getters.");
}

main().then(() => process.exit(0)).catch((err) => {
  console.error(err);
  process.exit(1);
});
