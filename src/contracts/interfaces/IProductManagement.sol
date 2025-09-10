// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../libraries/DataTypes.sol";

/**
 * @title IProductManagement
 * @notice Interface for Product Management functionality
 */
interface IProductManagement {
    
    function addProduct(DataTypes.ProductInput memory _productData) external;
    
    function updateProduct(
        string memory _productCode,
        string memory _name,
        string memory _quantity,
        string memory _price,
        string memory _description,
        string memory _image,
        string memory _batchCode,
        string memory _certification
    ) external;
    
    function deactivateProduct(string memory _productCode) external;
    
    function getProduct(string memory _productCode) external view returns (DataTypes.Product memory);
    
    function getProductByFarmCode(string memory _farmCode) external view returns (DataTypes.Product[] memory);
}
