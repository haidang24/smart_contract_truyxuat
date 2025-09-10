// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../libraries/DataTypes.sol";

/**
 * @title IFarmManagement
 * @notice Interface for Farm Management functionality
 */
interface IFarmManagement {
    
    function registerFarm(
        string memory _farmCode,
        string memory _fullname,
        string memory _nameFarm,
        string memory _userId,
        string memory _email,
        string memory _phone,
        string memory _description,
        string memory _location,
        uint256 _area,
        string[] memory _images
    ) external;
    
    function updateFarm(
        string memory _farmCode,
        string memory _nameFarm,
        string memory _description,
        string memory _location,
        uint256 _area,
        string[] memory _images
    ) external;
    
    function deactivateFarm(string memory _farmCode) external;
    
    function getFarm(string memory _farmCode) external view returns (DataTypes.Farm memory);
    
    function getFarmByUserId(string memory _userId) external view returns (DataTypes.Farm[] memory);
    
    function getAllFarms() external view returns (DataTypes.Farm[] memory);
}
