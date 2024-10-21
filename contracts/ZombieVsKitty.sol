// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./zombieattack.sol";  // Assuming you have this file for zombie attacks
import "./Kitty.sol";  // Importing your custom Kitty contract

contract ZombieVsKitty is ZombieAttack {
    Kitty public kittyContract;

    constructor(address _kittyContractAddress) {
        kittyContract = Kitty(_kittyContractAddress);  // Set the custom Kitty contract address
    }

    // Function to battle a Kitty with a Zombie
    function attackKitty(uint _zombieId, uint _kittyId) external onlyOwnerOf(_zombieId) {
        // Fetch the Zombie
        Zombie storage myZombie = zombies[_zombieId];

        // Fetch the Kitty
        (uint kittyGenes,, uint kittyLevel,,) = kittyContract.getKitty(_kittyId);

        // Battle logic (e.g., comparing genes or levels)
        if (myZombie.dna % 100 > kittyGenes % 100) {
            // Zombie wins
            myZombie.winCount++;
            myZombie.level++;
            kittyContract.recordKittyLoss(_kittyId);  // Record the Kitty's loss
            emit BattleOutcome(_zombieId, _kittyId, "Zombie Wins!");
        } else {
            // Kitty wins
            myZombie.lossCount++;
            kittyContract.recordKittyWin(_kittyId);  // Record the Kitty's win
            emit BattleOutcome(_zombieId, _kittyId, "Kitty Wins!");
        }
    }

    // Event to log battle outcomes
    event BattleOutcome(uint zombieId, uint kittyId, string result);
}
