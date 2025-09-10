// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title DataTypes
 * @notice Contains all data structures and enums used in the Agricultural Traceability System
 */
library DataTypes {
    
    // ===== ENUMS =====
    
    enum FarmStatus { ACTIVE, INACTIVE, SUSPENDED, PENDING_APPROVAL }
    enum ProductStatus { ACTIVE, INACTIVE, RECALLED, PENDING_VERIFICATION }
    enum CertificationLevel { NONE, BASIC, ORGANIC, PREMIUM, CERTIFIED }
    
    // ===== STRUCTS =====
    
    struct Farm {
        string farmCode;  
        string fullname;
        string nameFarm; 
        string userId; 
        string email; 
        string phone; 
        string description; 
        string location; 
        uint256 area;
        string[] images;
        uint256 createdAt;
        bool isActive;
    }

    struct Product {
        string farmCode; 
        string productCode; 
        string categoryName;
        string name; 
        string quantity; 
        string price; 
        string description;
        string image;
        string batchCode;
        string certification;
        uint256 createdAt;
        ProductStatus status;
        CertificationLevel certificationLevel;
    }

    struct FarmingProcess {
        string productCode;
        string nameProcess;
        string source;
        string plantingDate;
        string sowingDate;
        uint256 createdAt;
    }

    struct Medicine {
        string productCode;
        string nameMedicine;
        string quantityMedicine;
        string medicineDate;
        string medicineType;
        string applicationMethod;
        uint256 createdAt;
    }

    struct Fertilizer {
        string productCode;
        string nameFertilizer;
        string quantityFertilizer;
        string fertilizerDate;
        string fertilizerType;
        string applicationMethod;
        string expectedEffect;
        uint256 createdAt;
    }

    struct Harvest {
        string productCode;
        string harvestDate;
        string estimatedQuantity;
        string actualQuantity;
        string quality;
        string harvestMethod;
        uint256 createdAt;
    }

    struct Distribution {
        string productCode;
        string distributorName;
        string distributorPartner;
        string distributionDate;
        string transportMethod;
        string storageConditions;
        uint256 createdAt;
    }

    struct ProductInput {
        string farmCode;
        string productCode; 
        string categoryName;
        string name; 
        string quantity;
        string price;
        string description;
        string image;
        string batchCode;
        string certification;
        CertificationLevel certificationLevel;
    }
}
