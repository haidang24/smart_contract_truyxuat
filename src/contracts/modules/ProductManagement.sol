// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../interfaces/IProductManagement.sol";
import "../storage/TraceabilityStorage.sol";
import "../libraries/DataTypes.sol";

/**
 * @title ProductManagement
 * @notice Handles all product-related operations
 */
contract ProductManagement is IProductManagement, TraceabilityStorage {
    
    function addProduct(DataTypes.ProductInput memory _productData) external override {
        require(bytes(_productData.productCode).length > 0, "!productCode");
        require(bytes(_productData.name).length > 0, "!name");
        require(!productCodeExists[_productData.productCode], "exists");
        require(farmCodeExists[_productData.farmCode], "!farm");

        farmProducts[_productData.farmCode].push(_productData.productCode);
        productCodeExists[_productData.productCode] = true;
        productCount++;
        
        products[_productData.productCode] = DataTypes.Product({
            farmCode: _productData.farmCode,
            productCode: _productData.productCode,
            categoryName: _productData.categoryName,
            name: _productData.name,
            quantity: _productData.quantity,
            price: _productData.price,
            description: _productData.description,
            image: _productData.image,
            batchCode: _productData.batchCode,
            certification: _productData.certification,
            createdAt: block.timestamp,
            status: DataTypes.ProductStatus.ACTIVE,
            certificationLevel: _productData.certificationLevel
        });

        emit ProductAdded(_productData.farmCode, _productData.productCode, _productData.categoryName, DataTypes.ProductStatus.ACTIVE, block.timestamp);
    }

    function updateProduct(
        string memory _productCode,
        string memory _name,
        string memory _quantity,
        string memory _price,
        string memory _description,
        string memory _image,
        string memory _batchCode,
        string memory _certification
    ) external override productExists(_productCode) {
        DataTypes.Product storage product = products[_productCode];
        require(product.status == DataTypes.ProductStatus.ACTIVE, "!active");
        
        if (bytes(_name).length > 0) product.name = _name;
        if (bytes(_quantity).length > 0) product.quantity = _quantity;
        if (bytes(_price).length > 0) product.price = _price;
        if (bytes(_description).length > 0) product.description = _description;
        if (bytes(_image).length > 0) product.image = _image;
        if (bytes(_batchCode).length > 0) product.batchCode = _batchCode;
        if (bytes(_certification).length > 0) product.certification = _certification;
        
        emit ProductUpdated(_productCode, msg.sender, block.timestamp);
    }

    function deactivateProduct(string memory _productCode) external override productExists(_productCode) {
        DataTypes.Product storage product = products[_productCode];
        require(product.status == DataTypes.ProductStatus.ACTIVE, "!active");
        DataTypes.ProductStatus oldStatus = product.status;
        product.status = DataTypes.ProductStatus.INACTIVE;
        emit ProductStatusChanged(_productCode, oldStatus, DataTypes.ProductStatus.INACTIVE, block.timestamp);
    }

    function getProduct(string memory _productCode) external view override productExists(_productCode) returns (DataTypes.Product memory) {
        return products[_productCode];
    }

    function getProductByFarmCode(string memory _farmCode) external view override farmExists(_farmCode) returns (DataTypes.Product[] memory) {
        string[] memory productCodes = farmProducts[_farmCode];
        DataTypes.Product[] memory productArray = new DataTypes.Product[](productCodes.length);
        for (uint i = 0; i < productCodes.length; i++) {
            productArray[i] = products[productCodes[i]];
        }
        return productArray;
    }
}
