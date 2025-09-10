// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./modules/FarmManagement.sol";
import "./modules/ProductManagement.sol";
import "./modules/ProcessManagement.sol";
import "./libraries/DataTypes.sol";

/**
 * @title AgriculturalTraceabilitySystem
 * @notice Main contract that combines all modules for agricultural traceability
 * @dev This contract inherits from all management modules to provide a unified interface
 */
contract AgriculturalTraceabilitySystem is 
    FarmManagement, 
    ProductManagement, 
    ProcessManagement 
{
    
    string public constant VERSION = "2.0.0";
    string public constant NAME = "Agricultural Traceability System";
    
    /**
     * @notice Contract constructor
     * @dev Initializes the contract and sets the deployer as owner
     */
    constructor() {
        // Constructor logic is handled by TraceabilityStorage
    }
    
    /**
     * @notice Get contract information
     * @return name The contract name
     * @return version The contract version
     * @return totalFarms Total number of registered farms
     * @return totalProducts Total number of registered products
     * @return contractOwner Address of the contract owner
     */
    function getContractInfo() external view returns (
        string memory name,
        string memory version,
        uint256 totalFarms,
        uint256 totalProducts,
        address contractOwner
    ) {
        return (
            NAME,
            VERSION,
            farmCount,
            productCount,
            owner
        );
    }
    
    /**
     * @notice Emergency pause function (only owner)
     * @dev Can be used to pause contract operations in case of emergency
     */
    function emergencyPause() external onlyOwner {
        // Implementation for emergency pause if needed
        // This is a placeholder for future emergency functionality
    }
    
    /**
     * @notice Transfer ownership (only current owner)
     * @param newOwner Address of the new owner
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "!newOwner");
        owner = newOwner;
    }
}
