// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title FitBurn (CAL) - Fitness Tracking & Rewards Contract
 * @dev A smart contract that rewards users with CAL tokens for burning calories
 */
contract FitBurn {
    
    // Token details
    string public constant name = "Calorie Token";
    string public constant symbol = "CAL";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    
    // Mapping from address to token balance
    mapping(address => uint256) public balanceOf;
    
    // User fitness data structure
    struct User {
        uint256 totalCalories;     // Total calories burned by user
        uint256 calBalance;        // CAL token balance
        uint256 activitiesCount;   // Number of activities logged
        uint256 lastActivityTime;  // Timestamp of last activity
    }
    
    // Mapping from address to user data
    mapping(address => User) public users;
    
    // Array to track all active users for leaderboard
    address[] public activeUsers;
    mapping(address => bool) public isActiveUser;
    
    // Events
    event ActivityLogged(address indexed user, uint256 caloriesBurned, uint256 tokensEarned);
    event TokenTransfer(address indexed from, address indexed to, uint256 value);
    
    /**
     * @dev Constructor initializes the contract
     */
    constructor() {
        totalSupply = 0; // Tokens are minted as rewards
    }
    
    /**
     * @dev Core Function 1: Log fitness activity and earn CAL tokens
     * @param caloriesBurned Number of calories burned in the activity
     */
    function logActivity(uint256 caloriesBurned) external {
        require(caloriesBurned > 0, "Calories must be greater than 0");
        require(caloriesBurned <= 2000, "Unrealistic calorie count"); // Prevent abuse
        
        // Add user to active users list if first time
        if (!isActiveUser[msg.sender]) {
            activeUsers.push(msg.sender);
            isActiveUser[msg.sender] = true;
        }
        
        // Update user data
        users[msg.sender].totalCalories += caloriesBurned;
        users[msg.sender].activitiesCount += 1;
        users[msg.sender].lastActivityTime = block.timestamp;
        
        // Mint CAL tokens as reward (1 calorie = 1 CAL token)
        uint256 tokensToMint = caloriesBurned * 10**decimals;
        balanceOf[msg.sender] += tokensToMint;
        users[msg.sender].calBalance += tokensToMint;
        totalSupply += tokensToMint;
        
        emit ActivityLogged(msg.sender, caloriesBurned, tokensToMint);
    }
    
    /**
     * @dev Core Function 2: Get user's fitness stats and token balance
     * @param userAddress Address of the user to query
     * @return totalCalories Total calories burned by user
     * @return calBalance CAL token balance
     * @return activitiesCount Number of activities logged
     * @return lastActivityTime Timestamp of last activity
     */
    function getUser(address userAddress) external view returns (
        uint256 totalCalories,
        uint256 calBalance,
        uint256 activitiesCount,
        uint256 lastActivityTime
    ) {
        User memory user = users[userAddress];
        return (
            user.totalCalories,
            user.calBalance,
            user.activitiesCount,
            user.lastActivityTime
        );
    }
    
    /**
     * @dev Core Function 3: Get leaderboard of top users by calories burned
     * @return topUsers Array of top 10 user addresses
     * @return topCalories Array of corresponding calorie counts
     */
    function getLeaderboard() external view returns (
        address[] memory topUsers,
        uint256[] memory topCalories
    ) {
        uint256 userCount = activeUsers.length;
        uint256 leaderboardSize = userCount > 10 ? 10 : userCount;
        
        topUsers = new address[](leaderboardSize);
        topCalories = new uint256[](leaderboardSize);
        
        // Simple bubble sort for top users (inefficient but works for demo)
        address[] memory sortedUsers = new address[](userCount);
        uint256[] memory sortedCalories = new uint256[](userCount);
        
        // Copy data
        for (uint256 i = 0; i < userCount; i++) {
            sortedUsers[i] = activeUsers[i];
            sortedCalories[i] = users[activeUsers[i]].totalCalories;
        }
        
        // Bubble sort (descending order)
        for (uint256 i = 0; i < userCount; i++) {
            for (uint256 j = 0; j < userCount - i - 1; j++) {
                if (sortedCalories[j] < sortedCalories[j + 1]) {
                    // Swap calories
                    uint256 tempCalories = sortedCalories[j];
                    sortedCalories[j] = sortedCalories[j + 1];
                    sortedCalories[j + 1] = tempCalories;
                    
                    // Swap addresses
                    address tempUser = sortedUsers[j];
                    sortedUsers[j] = sortedUsers[j + 1];
                    sortedUsers[j + 1] = tempUser;
                }
            }
        }
        
        // Return top users
        for (uint256 i = 0; i < leaderboardSize; i++) {
            topUsers[i] = sortedUsers[i];
            topCalories[i] = sortedCalories[i];
        }
        
        return (topUsers, topCalories);
    }
    
    /**
     * @dev Get total number of active users
     */
    function getTotalActiveUsers() external view returns (uint256) {
        return activeUsers.length;
    }
    
    /**
     * @dev Basic token transfer function
     * @param to Recipient address
     * @param amount Amount of tokens to transfer
     */
    function transfer(address to, uint256 amount) external returns (bool) {
        require(to != address(0), "Cannot transfer to zero address");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        
        // Update user balances in fitness tracking
        users[msg.sender].calBalance -= amount;
        if (!isActiveUser[to]) {
            activeUsers.push(to);
            isActiveUser[to] = true;
        }
        users[to].calBalance += amount;
        
        emit TokenTransfer(msg.sender, to, amount);
        return true;
    }
}
