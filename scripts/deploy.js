const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Starting deployment of RentPaymentSystem...");
  
  // Get network info
  const network = hre.network.name;
  const chainId = hre.network.config.chainId;
  
  console.log(`📡 Network: ${network}`);
  console.log(`🔗 Chain ID: ${chainId}`);
  
  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log(`👤 Deploying with account: ${deployer.address}`);
  
  // Check deployer balance
  const balance = await deployer.provider.getBalance(deployer.address);
  console.log(`💰 Account balance: ${ethers.formatEther(balance)} ETH`);
  
  // Deploy the contract
  console.log("\n📦 Deploying RentPaymentSystem contract...");
  
  const RentPaymentSystem = await ethers.getContractFactory("RentPaymentSystem");
  const rentPaymentSystem = await RentPaymentSystem.deploy();
  
  // Wait for deployment to complete
  await rentPaymentSystem.waitForDeployment();
  
  const contractAddress = await rentPaymentSystem.getAddress();
  console.log(`✅ RentPaymentSystem deployed to: ${contractAddress}`);
  
  // Get deployment transaction
  const deploymentTx = rentPaymentSystem.deploymentTransaction();
  console.log(`📄 Deployment transaction hash: ${deploymentTx.hash}`);
  
  // Wait for a few confirmations
  console.log("⏳ Waiting for confirmations...");
  await deploymentTx.wait(2);
  console.log("✅ Contract confirmed!");
  
  // Display contract information
  console.log("\n📋 Contract Information:");
  console.log("==========================================");
  console.log(`Contract Name: RentPaymentSystem`);
  console.log(`Contract Address: ${contractAddress}`);
  console.log(`Network: ${network}`);
  console.log(`Chain ID: ${chainId}`);
  console.log(`Deployer: ${deployer.address}`);
  console.log(`Transaction Hash: ${deploymentTx.hash}`);
  
  // Verify contract constants
  try {
    const latePenaltyRate = await rentPaymentSystem.LATE_PENALTY_RATE();
    const gracePeriod = await rentPaymentSystem.GRACE_PERIOD();
    const secondsInMonth = await rentPaymentSystem.SECONDS_IN_MONTH();
    
    console.log("\n⚙️  Contract Constants:");
    console.log(`Late Penalty Rate: ${latePenaltyRate}%`);
    console.log(`Grace Period: ${gracePeriod} seconds (${Number(gracePeriod) / 86400} days)`);
    console.log(`Seconds in Month: ${secondsInMonth} seconds (${Number(secondsInMonth) / 86400} days)`);
  } catch (error) {
    console.log("⚠️  Could not fetch contract constants:", error.message);
  }
  
  // Save deployment info to file
  const fs = require('fs');
  const deploymentInfo = {
    network: network,
    chainId: chainId,
    contractAddress: contractAddress,
    deployerAddress: deployer.address,
    transactionHash: deploymentTx.hash,
    timestamp: new Date().toISOString(),
    blockNumber: deploymentTx.blockNumber
  };
  
  const deploymentFile = `deployments/${network}_deployment.json`;
  
  // Create deployments directory if it doesn't exist
  if (!fs.existsSync('deployments')) {
    fs.mkdirSync('deployments');
  }
  
  fs.writeFileSync(deploymentFile, JSON.stringify(deploymentInfo, null, 2));
  console.log(`💾 Deployment info saved to: ${deploymentFile}`);
  
  // Verification instructions
  if (network !== "hardhat" && network !== "localhost") {
    console.log("\n🔍 To verify the contract, run:");
    console.log(`npx hardhat verify --network ${network} ${contractAddress}`);
  }
  
  console.log("\n🎉 Deployment completed successfully!");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
