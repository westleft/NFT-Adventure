import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers, upgrades } from "hardhat";

describe("NFT", function () {
  const deployFixture = async () => {
    const [owner, otherAccount] = await ethers.getSigners();
    const Contract = await ethers.getContractFactory("NftAdventure");

    // 此為 proxyContract
    const contract = await upgrades.deployProxy(Contract, [], { initializer: 'initialize' });

    // 邏輯合約地址
    // const logicAddress = await contract.getImplementation();

    return { contract, owner, otherAccount };
  }

  describe("Deployment", async () => {
    it("確認合約 Gold 數量", async function () {
      const { contract } = await loadFixture(deployFixture);
      const goldAmount = await contract.balanceOf(contract.target, 0);
      expect(goldAmount).to.equal(10 ** 10);
    });

    it("建立 NFT", async () => {
      
    })
  });
});
