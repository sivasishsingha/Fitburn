# FitBurn (CAL)

## Project Description

FitBurn (CAL) is a decentralized fitness tracking and rewards platform built on blockchain technology. The smart contract enables users to log their fitness activities, track calories burned, and earn CAL tokens as rewards for maintaining an active lifestyle.

## Features

- **Activity Logging**: Users can record their fitness activities with calories burned
- **Token Rewards**: Earn CAL tokens based on calories burned (1 calorie = 1 CAL token)
- **Progress Tracking**: Monitor total calories burned and tokens earned
- **Leaderboard System**: Track top performers in the fitness community

## Smart Contract Functions

### Core Functions

1. **logActivity(uint256 caloriesBurned)**: Log a fitness activity and earn CAL tokens
2. **getUser(address userAddress)**: Retrieve user's fitness stats and token balance
3. **getLeaderboard()**: Get top 10 users by total calories burned

## Getting Started

### Prerequisites

- Node.js and npm
- Hardhat or Truffle framework
- MetaMask wallet
- Test ETH for deployment

### Installation

1. Clone the repository
2. Install dependencies: `npm install`
3. Compile contracts: `npx hardhat compile`
4. Deploy to testnet: `npx hardhat run scripts/deploy.js --network sepolia`

## Contract Details

- **Token Standard**: ERC-20 compatible CAL tokens
- **Reward Rate**: 1 CAL token per calorie burned
- **Network**: Ethereum (deployable to any EVM-compatible chain)

## Usage Example

```javascript
// Log a workout that burned 300 calories
await fitBurnContract.logActivity(300);

// Check your stats
const userStats = await fitBurnContract.getUser(userAddress);
console.log(`Total calories: ${userStats.totalCalories}`);
console.log(`CAL balance: ${userStats.calBalance}`);
```

## Future Enhancements

- Integration with fitness wearables (Fitbit, Apple Watch)
- Staking mechanisms for long-term fitness commitments   
- NFT achievements for fitness milestones
- Social features and challenges between users

## License


MIT License
contact address : 0x4Cd5D2E6346Be066A10cf7C8D05030F67bD62760
