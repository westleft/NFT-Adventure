import { ethers } from "hardhat";

const networkConfig = {
  11155111: {
    name: "sepolia",
  },
  31337: {
    name: "hardhat",
  }
}

const developmentChain = ["hardhat", "localhost"];

module.exports = {
  networkConfig,
  developmentChain
}