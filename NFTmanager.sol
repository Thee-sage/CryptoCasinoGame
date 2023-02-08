// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NFTManager {
struct NFT {
uint256 id;
string name;
string url;
address owner;
}
mapping (uint256 => NFT) public nfts;
mapping(uint256 => address) private _tokenOwners;
 function isOwner(address from, uint256 tokenId) public view returns (bool) {
        return from == _tokenOwners[tokenId];
    }
uint256 public nftCounter = 0;

function addNFT(string memory _name, string memory _url) public {
    nftCounter++;
    nfts[nftCounter].id = nftCounter;
    nfts[nftCounter].name = _name;
    nfts[nftCounter].url = _url;
    nfts[nftCounter].owner = msg.sender;
}

function updateNFT(uint256 _id, string memory _name, string memory _url) public {
    require(nfts[_id].owner == msg.sender, "You do not have permission to update this NFT");
    nfts[_id].name = _name;
    nfts[_id].url = _url;
}

function transferNFT(uint256 _id, address _to) public {
    require(nfts[_id].owner == msg.sender, "You do not have permission to transfer this NFT");
    nfts[_id].owner = _to;
}

function getNFT(uint256 _id) public view returns (uint256, string memory, string memory, address) {
    return (nfts[_id].id, nfts[_id].name, nfts[_id].url, nfts[_id].owner);
}
function isValid(uint256 nftId) public view returns (bool) {
    // Implementation to check if the NFT is valid
}
function isStable(uint256 nftId)public view returns (bool) {
  }
  function transferFrom(address from, address to, uint256 tokenId) public {
    require(isOwner(from, tokenId), "from address is not the owner of the token");
    _transfer(from, to, tokenId);
}
event transfer(address indexed from, address indexed to, uint256 tokenId);

function _transfer(address from, address to, uint256 tokenId) internal {
    require(from != address(0), "from address is the zero address");
    require(to != address(0), "to address is the zero address");

     _tokenOwners[tokenId] = to;
    emit transfer(from, to, tokenId);
}

}
