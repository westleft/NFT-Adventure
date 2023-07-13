import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers, upgrades } from "hardhat";

describe("NFT", function () {
  const deployFixture = async () => {
    const [owner, otherAccount] = await ethers.getSigners();
    const Contract = await ethers.getContractFactory("NftAdventure");
    // console.log(await ethers.provider.getBalance(owner))

    const contract = await upgrades.deployProxy(Contract, [], { initializer: 'initialize' });

    return { contract, owner, otherAccount };
  }

  describe("Deployment", async () => {
    it("確認合約 Gold 數量", async function () {
      const { contract } = await loadFixture(deployFixture);
      const goldAmount = await contract.balanceOf(contract.target, 0);
      expect(goldAmount).to.equal(10 ** 10);
    });

    it("建立 NFT", async () => {
      const { contract } = await loadFixture(deployFixture);
      await contract.createNFT(1, 2, "0x");
      const nftBalance = await contract.balanceOf(contract.target, 1);
      expect(nftBalance).to.equal(2);
    })

    it("購買 GOLD + NFT", async () => {
      const { contract, owner } = await loadFixture(deployFixture);
      await contract.createNFT(1, 1, "0x");

      await contract.buyGold({ value: ethers.parseEther("0.001") });
      const ownerGoldBalance = await contract.balanceOf(owner.address, 0);
      expect(ownerGoldBalance).to.equal(100000);

      await contract.buyNFT(1, 10000);
      const ownerNftBalance = await contract.balanceOf(owner.address, 1);
      expect(ownerNftBalance).to.equal(1);
    })

    it("新增管理員", async () => {
      const { contract, owner, otherAccount } = await loadFixture(deployFixture);
      await contract.addAdmin(otherAccount)
      await contract.connect(otherAccount).createNFT(1, 2, "0x")
      expect(await contract.balanceOf(contract.target, 1)).to.equal(2);
    })

    it("UUPS", async () => {
      const { contract } = await loadFixture(deployFixture);
      const ContractV2 = await ethers.getContractFactory("NftAdventureV2");
      const contractV2 = await upgrades.upgradeProxy(contract, ContractV2)
      
      await contractV2.createNFT(5, 1, "0x");
      const nftBalance = await contractV2.balanceOf(contractV2.target, 5);
      expect(nftBalance).to.equal(1);
    })
  });
});
