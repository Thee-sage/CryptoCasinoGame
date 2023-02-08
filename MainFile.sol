// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./NFTmanager.sol";

contract MainFile is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(address => uint256) public playerStake;
    mapping(address => uint256) public playerStakeAge;
    mapping(address => bool) public playerInGame;

    // Contract instance of the NFT Manager
    NFTManager public nftManager;

    constructor() ERC721("In-game-token-which-are-your-nfts","igt") {
        nftManager = new NFTManager();
    }

    function depositStake(address player, uint256 nftId, uint256 age) public {
        require(isValidNFT(nftId), "NFT is not valid");
        require(isStableNFT(nftId), "NFT is not stable");
        require(block.timestamp - age >= 86400, "NFT must have been on the Polygon network for at least 24 hours");
        playerStake[player] = nftId;
        playerStakeAge[player] = age;
    }

  function isValidNFT(uint256 nftId) internal view returns (bool) {
    return nftManager.isValid(nftId);
}


function isStableNFT(uint256 nftId) internal view returns (bool) {
    return nftManager.isStable(nftId);
}
function transferNFTToWinner(address winner) public {
    // Check that the player is in the game and has deposited a stake
    require(playerInGame[winner], "Player is not in the game");
    require(playerStake[winner] != 0, "Player has not deposited a stake");

    // Get the NFT ID of the player's stake
    uint256 nftId = playerStake[winner];

    // Transfer the NFT to the winner
    address owner = address(this);
    nftManager.transferFrom(owner, winner, nftId);

    // Reset the player's stake and game status
    playerStake[winner] = 0;
    playerInGame[winner] = false;
}

}
