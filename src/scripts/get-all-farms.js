const { ethers } = require("hardhat");
const fs = require("fs");

async function main() {
  const dep = JSON.parse(fs.readFileSync("deployment-info-modular.json", "utf8"));
  const address = dep.contractAddress;
  if (!address) throw new Error("No contractAddress in deployment-info-modular.json");

  const Factory = await ethers.getContractFactory(
    "src/contracts/AgriculturalTraceabilitySystem.sol:AgriculturalTraceabilitySystem"
  );
  const [signer] = await ethers.getSigners();
  const contract = new ethers.Contract(address, (await Factory.interface).format(), signer);

  console.log("=== getAllFarms ===");
  try {
    const farms = await contract.getAllFarms();
    console.log(`Total: ${farms.length}`);
    farms.forEach((f, i) => {
      console.log(
        `${i + 1}. code=${f.farmCode}, nameFarm=${f.nameFarm}, ownerUser=${f.userId}, area=${f.area.toString()}, active=${f.isActive}`
      );
    });
  } catch (e) {
    console.error("getAllFarms error:", e.message);
    process.exit(1);
  }
}

main().then(() => process.exit(0)).catch(err => { console.error(err); process.exit(1); });
