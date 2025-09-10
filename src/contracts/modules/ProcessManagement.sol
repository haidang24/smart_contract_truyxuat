// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../interfaces/IProcessManagement.sol";
import "../storage/TraceabilityStorage.sol";
import "../libraries/DataTypes.sol";

/**
 * @title ProcessManagement
 * @notice Handles all agricultural process-related operations
 */
contract ProcessManagement is IProcessManagement, TraceabilityStorage {
    
    function addFarmingProcess(
        string memory _productCode,
        string memory _nameProcess,
        string memory _source,
        string memory _plantingDate,
        string memory _sowingDate
    ) external override productExists(_productCode) {
        require(bytes(_nameProcess).length > 0, "!process");
        require(bytes(_plantingDate).length > 0, "!date");
        require(products[_productCode].status == DataTypes.ProductStatus.ACTIVE, "!active");
        
        farmingProcesses[_productCode] = DataTypes.FarmingProcess({
            productCode: _productCode,
            nameProcess: _nameProcess,
            source: _source,
            plantingDate: _plantingDate,
            sowingDate: _sowingDate,
            createdAt: block.timestamp
        });

        emit FarmingProcessAdded(_productCode, msg.sender, block.timestamp);
    }

    function addMedicine(
        string memory _productCode,
        string memory _nameMedicine,
        string memory _quantityMedicine,
        string memory _medicineDate,
        string memory _medicineType,
        string memory _applicationMethod
    ) external override productExists(_productCode) {
        require(bytes(_nameMedicine).length > 0, "!medicine");
        require(bytes(_medicineDate).length > 0, "!date");
        require(products[_productCode].status == DataTypes.ProductStatus.ACTIVE, "!active");
        
        medicines[_productCode] = DataTypes.Medicine({
            productCode: _productCode,
            nameMedicine: _nameMedicine,
            quantityMedicine: _quantityMedicine,
            medicineDate: _medicineDate,
            medicineType: _medicineType,
            applicationMethod: _applicationMethod,
            createdAt: block.timestamp
        });

        emit MedicineAdded(_productCode, msg.sender, block.timestamp);
    }

    function addFertilizer(
        string memory _productCode,
        string memory _nameFertilizer,
        string memory _quantityFertilizer,
        string memory _fertilizerDate,
        string memory _fertilizerType,
        string memory _applicationMethod,
        string memory _expectedEffect
    ) external override productExists(_productCode) {
        require(bytes(_nameFertilizer).length > 0, "!fertilizer");
        require(bytes(_fertilizerDate).length > 0, "!date");
        require(products[_productCode].status == DataTypes.ProductStatus.ACTIVE, "!active");
        
        fertilizers[_productCode] = DataTypes.Fertilizer({
            productCode: _productCode,
            nameFertilizer: _nameFertilizer,
            quantityFertilizer: _quantityFertilizer,
            fertilizerDate: _fertilizerDate,
            fertilizerType: _fertilizerType,
            applicationMethod: _applicationMethod,
            expectedEffect: _expectedEffect,
            createdAt: block.timestamp
        });

        emit FertilizerAdded(_productCode, msg.sender, block.timestamp);
    }

    function addHarvest(
        string memory _productCode,
        string memory _harvestDate,
        string memory _estimatedQuantity,
        string memory _actualQuantity,
        string memory _quality,
        string memory _harvestMethod
    ) external override productExists(_productCode) {
        require(bytes(_harvestDate).length > 0, "!date");
        require(products[_productCode].status == DataTypes.ProductStatus.ACTIVE, "!active");
        
        harvests[_productCode] = DataTypes.Harvest({
            productCode: _productCode,
            harvestDate: _harvestDate,
            estimatedQuantity: _estimatedQuantity,
            actualQuantity: _actualQuantity,
            quality: _quality,
            harvestMethod: _harvestMethod,
            createdAt: block.timestamp
        });

        emit HarvestAdded(_productCode, msg.sender, block.timestamp);
    }

    function addDistribution(
        string memory _productCode,
        string memory _distributorName,
        string memory _distributorPartner,
        string memory _distributionDate,
        string memory _transportMethod,
        string memory _storageConditions
    ) external override productExists(_productCode) {
        require(bytes(_distributorName).length > 0, "!distributor");
        require(bytes(_distributionDate).length > 0, "!date");
        require(products[_productCode].status == DataTypes.ProductStatus.ACTIVE, "!active");
        
        distributions[_productCode] = DataTypes.Distribution({
            productCode: _productCode,
            distributorName: _distributorName,
            distributorPartner: _distributorPartner,
            distributionDate: _distributionDate,
            transportMethod: _transportMethod,
            storageConditions: _storageConditions,
            createdAt: block.timestamp
        });

        emit DistributionAdded(_productCode, msg.sender, block.timestamp);
    }

    function getCompleteProductTraceability(string memory _productCode) 
        external 
        view 
        override
        productExists(_productCode) 
        returns (
            DataTypes.Product memory product,
            DataTypes.FarmingProcess memory farmingProcess,
            DataTypes.Medicine memory medicine,
            DataTypes.Fertilizer memory fertilizer,
            DataTypes.Harvest memory harvest,
            DataTypes.Distribution memory distribution
        ) 
    {
        return (
            products[_productCode],
            farmingProcesses[_productCode],
            medicines[_productCode],
            fertilizers[_productCode],
            harvests[_productCode],
            distributions[_productCode]
        );
    }
}
