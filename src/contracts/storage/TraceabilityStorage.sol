// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../libraries/DataTypes.sol";

/**
 * @title TraceabilityStorage
 * @notice Manages all storage mappings and arrays for the traceability system
 */
contract TraceabilityStorage {
    using DataTypes for *;
    
    // ===== MAPPINGS =====
    mapping(string => DataTypes.Farm) internal farms;
    mapping(string => DataTypes.Product) internal products;
    mapping(string => DataTypes.FarmingProcess) internal farmingProcesses;
    mapping(string => DataTypes.Medicine) internal medicines;
    mapping(string => DataTypes.Fertilizer) internal fertilizers;
    mapping(string => DataTypes.Harvest) internal harvests;
    mapping(string => DataTypes.Distribution) internal distributions;
    
    mapping(string => string[]) internal userFarms;
    mapping(string => string[]) internal farmProducts;
    mapping(string => bool) internal farmCodeExists;
    mapping(string => bool) internal productCodeExists;
    
    // Array to store all farm codes for getAllFarms function
    string[] internal allFarmCodes;
    
    // ===== COUNTERS =====
    uint256 internal farmCount;
    uint256 internal productCount;
    
    // ===== CONSTANTS =====
    uint256 public constant MAX_AREA = 1000000;
    uint256 public constant MAX_IMAGES = 10;
    uint256 public constant MIN_AREA = 1;
    
    // ===== STATE VARIABLES =====
    address public owner;
    
    // ===== EVENTS =====
    event FarmRegistered(
        string indexed farmCode, 
        string indexed userId, 
        address indexed owner, 
        uint256 area,
        uint256 timestamp
    );
    
    event ProductAdded(
        string indexed farmCode, 
        string indexed productCode, 
        string indexed categoryName,
        DataTypes.ProductStatus status,
        uint256 timestamp
    );
    
    event FarmUpdated(string indexed farmCode, address indexed updater, uint256 timestamp);
    event ProductUpdated(string indexed productCode, address indexed updater, uint256 timestamp);
    event FarmStatusChanged(string indexed farmCode, DataTypes.FarmStatus oldStatus, DataTypes.FarmStatus newStatus, uint256 timestamp);
    event ProductStatusChanged(string indexed productCode, DataTypes.ProductStatus oldStatus, DataTypes.ProductStatus newStatus, uint256 timestamp);
    
    // Process Events
    event FarmingProcessAdded(string indexed productCode, address indexed creator, uint256 timestamp);
    event MedicineAdded(string indexed productCode, address indexed creator, uint256 timestamp);
    event FertilizerAdded(string indexed productCode, address indexed creator, uint256 timestamp);
    event HarvestAdded(string indexed productCode, address indexed creator, uint256 timestamp);
    event DistributionAdded(string indexed productCode, address indexed creator, uint256 timestamp);
    
    // ===== MODIFIERS =====
    
    modifier farmExists(string memory _farmCode) {
        require(farmCodeExists[_farmCode], "!farm");
        _;
    }
    
    modifier productExists(string memory _productCode) {
        require(productCodeExists[_productCode], "!product");
        _;
    }
    
    modifier validArea(uint256 _area) {
        require(_area >= MIN_AREA && _area <= MAX_AREA, "!area");
        _;
    }
    
    modifier validImageCount(uint256 _imageCount) {
        require(_imageCount <= MAX_IMAGES, "!images");
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "!owner");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        farmCount = 0;
        productCount = 0;
    }
}
