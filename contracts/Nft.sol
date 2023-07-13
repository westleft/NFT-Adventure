// SPDX-License-Identifier: MIT
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
contract NftAdventure is Initializable, ERC1155Upgradeable, OwnableUpgradeable, PausableUpgradeable, ERC1155BurnableUpgradeable, ERC1155SupplyUpgradeable, UUPSUpgradeable {
    event BuyNFT(address indexed buyer, uint256 tokenId, uint256 amount);

    uint256 public constant GOLD_TOKEN_ID = 0;
    uint256 public constant ETH_TO_GOLD_RATE = 100000;
    string public constant name = "NFT-Adventure";

    mapping (address => bool) public admins;

    modifier onlyAdmin {
        require(admins[msg.sender], "You are not admin");
        _;        
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC1155_init("https://gateway.pinata.cloud/ipfs/QmZMUM2csptJC4rVKHgyiTH5kd4nikYnRACzpWvbiDxajQ/{id}.json");
        __Ownable_init();
        __Pausable_init();
        __ERC1155Burnable_init();
        __ERC1155Supply_init();
        __UUPSUpgradeable_init();

        __Token_init();
        admins[msg.sender] = true;
    }

    function __Token_init() private onlyOwner {
        _mint(address(this), GOLD_TOKEN_ID, 10**10, "");
    }

    // 建立 NFT
    function createNFT(uint256 id, uint256 amount, bytes memory data) public onlyAdmin {
        _mint(address(this), id, amount, data);
    }

    // 使用 GOLD 購買 NFT
    function buyNFT(uint256 tokenId, uint256 goldAmount) payable public whenNotPaused {
        if (goldAmount < 10000) revert NftAdventure__PaymentNotEnough();
        if (balanceOf(msg.sender, GOLD_TOKEN_ID) < 10000) revert NftAdventure__GoldNotEnough();
        if (tokenId == 0) revert ("Token id 0 is not nft");
        if (!exists(tokenId)) revert ("exists token id"); 
        if (balanceOf(address(this), tokenId) <= 0) revert ("Sold out!");

        safeTransferFrom(msg.sender, address(this), GOLD_TOKEN_ID, 10000, "");

        _setApprovalForAll(address(this), msg.sender, true);
        safeTransferFrom(address(this), msg.sender, tokenId, 1, "");
        emit BuyNFT(msg.sender, tokenId, 1);
    }

    // 將 ETH 換成 GOLD
    function buyGold() public payable {
        if (msg.value < 0.001 ether) revert NftAdventure__PaymentNotEnough();
        (bool success, ) = (msg.sender).call{value: msg.value}("");
        if (!success) revert NftAdventure__TransferFailed();

        _setApprovalForAll(address(this), msg.sender, true);
        safeTransferFrom(address(this), msg.sender, GOLD_TOKEN_ID, (msg.value / 1e15) * ETH_TO_GOLD_RATE, ""); 
        emit BuyNFT(msg.sender, 0, 1);
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

    function addAdmin(address admin) external onlyOwner {
        admins[admin] = true;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155Upgradeable, ERC1155SupplyUpgradeable)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function getImplementation() external view returns(address) {
        return _getImplementation();
    }
}
