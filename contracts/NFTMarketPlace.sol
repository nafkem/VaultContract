// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {
    // SafeMath library functions here...
}

contract MarketPlace is ERC721 {
    using SafeMath for uint256;

    struct Listing {
        uint256 price;
        bool isForSale;
    }

    mapping(uint256 => Listing) private _listings;
    mapping(uint256 => address) private _tokenOwners;

    event NFTListed(uint256 indexed tokenId, uint256 price);
    event NFTUnlisted(uint256 indexed tokenId);
    event NFTSold(uint256 indexed tokenId, address indexed buyer, uint256 price);

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    modifier onlyOwnerOf(uint256 tokenId) {
        require(_msgSender() == ownerOf(tokenId), "Not the owner of the token");
        _;
    }

    function listNFTForSale(uint256 tokenId, uint256 price) external onlyOwnerOf(tokenId) {
        require(price > 0, "Price must be greater than zero");

        _listings[tokenId] = Listing(price, true);
        emit NFTListed(tokenId, price);
    }

    function unlistNFT(uint256 tokenId) external onlyOwnerOf(tokenId) {
        delete _listings[tokenId];
        emit NFTUnlisted(tokenId);
    }

    function buyNFT(uint256 tokenId) external payable {
        Listing memory listing = _listings[tokenId];
        require(listing.isForSale, "NFT is not for sale");
        require(msg.value >= listing.price, "Insufficient funds");

        address seller = ownerOf(tokenId);
        _transfer(seller, _msgSender(), tokenId);

        delete _listings[tokenId];
        emit NFTSold(tokenId, _msgSender(), msg.value);

        if (msg.value > listing.price) {
            payable(seller).transfer(msg.value - listing.price); // Refund excess payment to the buyer
        }
    }

    function getListing(uint256 tokenId) external view returns (uint256 price, bool isForSale) {
        Listing memory listing = _listings[tokenId];
        return (listing.price, listing.isForSale);
    }
}
