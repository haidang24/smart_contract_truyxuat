// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../interfaces/IFarmManagement.sol";
import "../storage/TraceabilityStorage.sol";
import "../libraries/DataTypes.sol";

/**
 * @title FarmManagement
 * @notice Handles all farm-related operations
 */
contract FarmManagement is IFarmManagement, TraceabilityStorage {
    
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
    ) external override validArea(_area) validImageCount(_images.length) {
        require(bytes(_farmCode).length > 0, "!farmCode");
        require(bytes(_fullname).length > 0, "!fullname");
        require(bytes(_nameFarm).length > 0, "!nameFarm");
        require(bytes(_userId).length > 0, "!userId");
        require(!farmCodeExists[_farmCode], "exists");

        userFarms[_userId].push(_farmCode);
        farmCodeExists[_farmCode] = true;
        allFarmCodes.push(_farmCode);
        farmCount++;
        
        farms[_farmCode] = DataTypes.Farm({
            farmCode: _farmCode,
            fullname: _fullname,
            nameFarm: _nameFarm,
            userId: _userId,
            email: _email,
            phone: _phone,
            description: _description,
            location: _location,
            area: _area,
            images: _images,
            createdAt: block.timestamp,
            isActive: true
        });

        emit FarmRegistered(_farmCode, _userId, msg.sender, _area, block.timestamp);
    }

    function updateFarm(
        string memory _farmCode,
        string memory _nameFarm,
        string memory _description,
        string memory _location,
        uint256 _area,
        string[] memory _images
    ) external override farmExists(_farmCode) validArea(_area) {
        DataTypes.Farm storage farm = farms[_farmCode];
        require(farm.isActive, "!active");
        
        if (bytes(_nameFarm).length > 0) farm.nameFarm = _nameFarm;
        if (bytes(_description).length > 0) farm.description = _description;
        if (bytes(_location).length > 0) farm.location = _location;
        if (_area > 0) farm.area = _area;
        if (_images.length > 0) farm.images = _images;
        
        emit FarmUpdated(_farmCode, msg.sender, block.timestamp);
    }

    function deactivateFarm(string memory _farmCode) external override farmExists(_farmCode) {
        DataTypes.Farm storage farm = farms[_farmCode];
        require(farm.isActive, "!active");
        farm.isActive = false;
    }

    function getFarm(string memory _farmCode) external view override farmExists(_farmCode) returns (DataTypes.Farm memory) {
        return farms[_farmCode];
    }

    function getFarmByUserId(string memory _userId) external view override returns (DataTypes.Farm[] memory) {
        string[] memory farmCodes = userFarms[_userId];
        DataTypes.Farm[] memory farmArray = new DataTypes.Farm[](farmCodes.length);
        for (uint i = 0; i < farmCodes.length; i++) {
            farmArray[i] = farms[farmCodes[i]];
        }
        return farmArray;
    }

    function getAllFarms() external view override returns (DataTypes.Farm[] memory) {
        require(allFarmCodes.length > 0, "!farms");
        DataTypes.Farm[] memory farmArray = new DataTypes.Farm[](allFarmCodes.length);
        for (uint i = 0; i < allFarmCodes.length; i++) {
            farmArray[i] = farms[allFarmCodes[i]];
        }
        return farmArray;
    }
}
