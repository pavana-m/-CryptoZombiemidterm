// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
  // Use OpenZeppelin's ERC721 implementation

contract Kitty is ERC721 {
    struct KittyStruct {
        uint256 genes;
        uint64 birthTime;
        uint32 level;
        uint32 winCount;
        uint32 lossCount;
    }

    KittyStruct[] public kitties;

    // Mapping from token ID to owner address
    mapping (uint256 => address) public kittyOwner;

    // Event for creating a new Kitty
    event NewKitty(uint256 kittyId, uint256 genes);

    constructor() ERC721("CryptoKitty", "CKT") {}

    // Function to create a new Kitty with specific genes
    function createKitty(uint256 _genes) public {
        KittyStruct memory _kitty = KittyStruct({
            genes: _genes,
            birthTime: uint64(block.timestamp),
            level: 1,
            winCount: 0,
            lossCount: 0
        });

        kitties.push(_kitty);
        uint256 newKittyId = kitties.length - 1;
        _mint(msg.sender, newKittyId);  // Uses OpenZeppelin's _mint function
        kittyOwner[newKittyId] = msg.sender;

        emit NewKitty(newKittyId, _genes);
    }

    // Function to get details about a specific Kitty
    function getKitty(uint256 _kittyId) public view returns (
        uint256 genes,
        uint64 birthTime,
        uint32 level,
        uint32 winCount,
        uint32 lossCount
    ) {
        KittyStruct storage kitty = kitties[_kittyId];
        return (
            kitty.genes,
            kitty.birthTime,
            kitty.level,
            kitty.winCount,
            kitty.lossCount
        );
    }

    // Function to level up a Kitty after winning a battle
    function levelUpKitty(uint256 _kittyId) external {
        require(kittyOwner[_kittyId] == msg.sender, "You must own the kitty to level it up.");
        KittyStruct storage kitty = kitties[_kittyId];
        kitty.level += 1;  // Direct arithmetic operation (SafeMath is no longer needed)
    }

    // Function to record a win for a Kitty
    function recordKittyWin(uint256 _kittyId) external {
        require(kittyOwner[_kittyId] == msg.sender, "You must own the kitty to record a win.");
        KittyStruct storage kitty = kitties[_kittyId];
        kitty.winCount += 1;  // Direct arithmetic operation
        kitty.level += 1;  // Optional: level up the kitty after a win
    }

    // Function to record a loss for a Kitty
    function recordKittyLoss(uint256 _kittyId) external {
        require(kittyOwner[_kittyId] == msg.sender, "You must own the kitty to record a loss.");
        KittyStruct storage kitty = kitties[_kittyId];
        kitty.lossCount += 1;  // Direct arithmetic operation
    }
}
