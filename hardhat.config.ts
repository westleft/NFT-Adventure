import { HardhatUserConfig } from "hardhat/config";
import { ethers } from "hardhat";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import "dotenv/config";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      accounts: [process.env.PRIVATE_KEY!],
      chainId: 11155111,
      allowUnlimitedContractSize: true,
      gasPrice: "auto"
    },
    localhost: {
      url: "http://127.0.0.1:8545/",
      chainId: 31337,
      allowUnlimitedContractSize: true,
    },
  },  
};

export default config;
