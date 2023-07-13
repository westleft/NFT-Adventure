// SPDX-License-Identifier: MIT
// 
// 此合約用來測試 UUPS 升級是否成功
// 

pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

error NftAdventure__PaymentNotEnough();
error NftAdventure__GoldNotEnough();
error NftAdventure__TransferFailed();

// NFT-Adventure
contract NftAdventureV2 is Initializable, ERC1155Upgradeable, OwnableUpgradeable, PausableUpgradeable, ERC1155BurnableUpgradeable, ERC1155SupplyUpgradeable, UUPSUpgradeable {
    
    uint256 public constant NFT_PRICE = 0.001 ether;
    uint256 public constant GOLD_TOKEN_ID = 0;
    uint256 public constant ETH_TO_GOLD_RATE = 100000;

    mapping (address => bool) public admins;

    // 建立 NFT
    function createNFT(uint256 id, uint256 amount, bytes memory data) public onlyOwner {
        _mint(address(this), id, amount, data);
    }

    function _authorizeUpgrade(address newImplementation) internal onlyOwner override {}

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    // 合約接收 NFT
    // address operator, address from, uint256 id, uint256 value, bytes memory data
    function onERC1155Received(address, address, uint256, uint256, bytes memory)
        public
        pure
        returns (bytes4)
    {
        return this.onERC1155Received.selector;
    }

    // 合約接收多個 NFT
    // address operator, address from, uint256[] memory ids, uint256[] memory values, bytes memory data
    function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory)
        public
        pure
        returns (bytes4)
    {
        return this.onERC1155BatchReceived.selector;
    }


    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155Upgradeable, ERC1155SupplyUpgradeable)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
