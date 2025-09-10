// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../libraries/DataTypes.sol";

/**
 * @title IProcessManagement
 * @notice Interface for Agricultural Process Management functionality
 */
interface IProcessManagement {
    
    function addFarmingProcess(
        string memory _productCode,
        string memory _nameProcess,
        string memory _source,
        string memory _plantingDate,
        string memory _sowingDate
    ) external;
    
    function addMedicine(
        string memory _productCode,
        string memory _nameMedicine,
        string memory _quantityMedicine,
        string memory _medicineDate,
        string memory _medicineType,
        string memory _applicationMethod
    ) external;
    
    function addFertilizer(
        string memory _productCode,
        string memory _nameFertilizer,
        string memory _quantityFertilizer,
        string memory _fertilizerDate,
        string memory _fertilizerType,
        string memory _applicationMethod,
        string memory _expectedEffect
    ) external;
    
    function addHarvest(
        string memory _productCode,
        string memory _harvestDate,
        string memory _estimatedQuantity,
        string memory _actualQuantity,
        string memory _quality,
        string memory _harvestMethod
    ) external;
    
    function addDistribution(
        string memory _productCode,
        string memory _distributorName,
        string memory _distributorPartner,
        string memory _distributionDate,
        string memory _transportMethod,
        string memory _storageConditions
    ) external;
    
    function getCompleteProductTraceability(string memory _productCode) 
        external 
        view 
        returns (
            DataTypes.Product memory product,
            DataTypes.FarmingProcess memory farmingProcess,
            DataTypes.Medicine memory medicine,
            DataTypes.Fertilizer memory fertilizer,
            DataTypes.Harvest memory harvest,
            DataTypes.Distribution memory distribution
        );
}
