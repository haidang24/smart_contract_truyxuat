const fs = require('fs');
const path = require('path');

function main() {
  const artifactPath = path.join(__dirname, '..', '..', 'build', 'artifacts', 'src', 'contracts', 'AgriculturalTraceabilitySystem.sol', 'AgriculturalTraceabilitySystem.json');
  if (!fs.existsSync(artifactPath)) {
    console.error('Artifact not found at', artifactPath);
    process.exit(1);
  }
  const artifact = JSON.parse(fs.readFileSync(artifactPath, 'utf8'));
  const out = {
    contractName: artifact.contractName,
    abi: artifact.abi,
  };
  const outPath = path.join(__dirname, '..', '..', 'web', 'abi.json');
  fs.writeFileSync(outPath, JSON.stringify(out, null, 2));
  console.log('✅ Exported ABI to', outPath);
}

main();
