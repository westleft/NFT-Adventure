import { network, ethers, upgrades } from "hardhat";

async function main() {
  if (network.name !== "sepolia") return;
  const Contract = await ethers.getContractFactory("NftAdventure");
  const contract = await upgrades.deployProxy(Contract, [], { initializer: 'initialize' });

  // await contract.deployed();
  console.log(`deployed to ${contract.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
