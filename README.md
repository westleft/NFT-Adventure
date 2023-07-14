# NFT-Adventure

合約地址：0x222FbB8e8d07e52989d965D4F5D3eBad65E4773B
網路：Sepolia Testnet

這是一個簡易的 `ERC1155` 合約，沒有開放給使用者 MINT，都是由合約端先將 NFT MINT 起來，使用者購買後再轉給他。


## 購買 NFT 流程：
1. 將 ETH 換成 GOLD（合約內的另一種 token，總發行量 10**10）
2. 呼叫合約 abi：buyNFT(tokenId) 。


## 其他功能
* `UUPS`（可升級合約）
* 新增管理員


## 部屬合約

```shell
npx hardhat run scripts/deploy.ts
```
