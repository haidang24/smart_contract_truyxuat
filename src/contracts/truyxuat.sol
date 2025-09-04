// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title AgriculturalTraceabilitySystem
 * @author Smart Contract Developer
 * @notice A comprehensive blockchain-based agricultural traceability system
 * @dev This contract manages farms, products, and complete agricultural processes
 */
contract AgriculturalTraceabilitySystem {
    
    // ===== ENUMS =====
    
    /**
     * @notice Farm status enumeration
     */
    enum FarmStatus {
        ACTIVE,
        INACTIVE,
        SUSPENDED,
        PENDING_APPROVAL
    }
    
    /**
     * @notice Product status enumeration
     */
    enum ProductStatus {
        ACTIVE,
        INACTIVE,
        RECALLED,
        PENDING_VERIFICATION
    }
    
    /**
     * @notice Certification level enumeration
     */
    enum CertificationLevel {
        NONE,
        BASIC,
        ORGANIC,
        PREMIUM,
        CERTIFIED
    }
    
    // ===== STRUCTS =====
    
    /**
     * @notice Farm information structure
     * @param farmCode Unique farm identifier
     * @param fullname Full name of farm owner
     * @param nameFarm Farm name
     * @param userId User identifier
     * @param email Contact email
     * @param phone Contact phone number
     * @param description Farm description
     * @param location Farm location
     * @param area Farm area in square meters
     * @param images Array of farm images
     * @param createdAt Creation timestamp
     * @param isActive Farm status
     */
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

    /**
     * @notice Product information structure (basic info only)
     * @param farmCode Farm identifier
     * @param productCode Unique product identifier
     * @param categoryName Product category
     * @param name Product name
     * @param quantity Product quantity
     * @param price Product price
     * @param description Product description
     * @param image Product image URL
     * @param batchCode Batch identifier
     * @param certification Certification information
     * @param createdAt Creation timestamp
     * @param status Product status
     * @param certificationLevel Certification level
     */
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

    /**
     * @notice Agricultural process information
     * @param productCode Product identifier
     * @param nameProcess Process name
     * @param source Product source
     * @param plantingDate Planting date
     * @param sowingDate Sowing date
     * @param createdAt Creation timestamp
     */
    struct FarmingProcess {
        string productCode;
        string nameProcess;
        string source;
        string plantingDate;
        string sowingDate;
        uint256 createdAt;
    }

    /**
     * @notice Medicine application information
     * @param productCode Product identifier
     * @param nameMedicine Medicine name
     * @param quantityMedicine Medicine quantity
     * @param medicineDate Application date
     * @param medicineType Medicine type
     * @param applicationMethod Application method
     * @param createdAt Creation timestamp
     */
    struct Medicine {
        string productCode;
        string nameMedicine;
        string quantityMedicine;
        string medicineDate;
        string medicineType;
        string applicationMethod;
        uint256 createdAt;
    }

    /**
     * @notice Fertilizer application information
     * @param productCode Product identifier
     * @param nameFertilizer Fertilizer name
     * @param quantityFertilizer Fertilizer quantity
     * @param fertilizerDate Application date
     * @param fertilizerType Fertilizer type
     * @param applicationMethod Application method
     * @param expectedEffect Expected effect
     * @param createdAt Creation timestamp
     */
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

    /**
     * @notice Harvest information
     * @param productCode Product identifier
     * @param harvestDate Harvest date
     * @param estimatedQuantity Estimated quantity
     * @param actualQuantity Actual harvested quantity
     * @param quality Quality assessment
     * @param harvestMethod Harvest method
     * @param createdAt Creation timestamp
     */
    struct Harvest {
        string productCode;
        string harvestDate;
        string estimatedQuantity;
        string actualQuantity;
        string quality;
        string harvestMethod;
        uint256 createdAt;
    }

    /**
     * @notice Distribution information
     * @param productCode Product identifier
     * @param distributorName Distributor name
     * @param distributorPartner Distribution partner
     * @param distributionDate Distribution date
     * @param transportMethod Transport method
     * @param storageConditions Storage conditions
     * @param createdAt Creation timestamp
     */
    struct Distribution {
        string productCode;
        string distributorName;
        string distributorPartner;
        string distributionDate;
        string transportMethod;
        string storageConditions;
        uint256 createdAt;
    }

    /**
     * @notice Product input structure for adding products
     * @dev Contains basic product information only
     */
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

    // ===== MAPPINGS =====
    mapping(string => Farm) private farms; //mapping trang trại
    mapping(string => Product) private products; //mapping sản phẩm
    mapping(string => FarmingProcess) private farmingProcesses; //mapping quy trình canh tác
    mapping(string => Medicine) private medicines; //mapping thuốc bảo vệ thực vật
    mapping(string => Fertilizer) private fertilizers; //mapping phân bón
    mapping(string => Harvest) private harvests; //mapping thu hoạch
    mapping(string => Distribution) private distributions; //mapping phân phối
    
    mapping(string => string[]) private userFarms; //mapping người dùng và trang trại
    mapping(string => string[]) private farmProducts; //mapping trang trại và sản phẩm
    mapping(string => bool) private farmCodeExists; //mapping mã trang trại
    mapping(string => bool) private productCodeExists; //mapping mã sản phẩm
    mapping(string => bool) private categoryExists; //mapping loại sản phẩm
    mapping(string => string[]) private userCategories; //mapping người dùng và loại sản phẩm
    
    // ===== ARRAYS =====
    string[] private allFarmCodes; //mảng mã trang trại
    string[] private allProductCodes; //mảng mã sản phẩm
    string[] private allCategories; //mảng loại sản phẩm
    
    // ===== COUNTERS =====
    uint256 private farmCount; //số lượng trang trại
    uint256 private productCount; //số lượng sản phẩm
    
    // ===== CONSTANTS =====
    uint256 public constant MAX_AREA = 1_000_000; // Maximum farm area in square meters
    uint256 public constant MAX_IMAGES = 10; // Maximum number of images per farm
    uint256 public constant MIN_AREA = 1; // Minimum farm area in square meters
    
    // ===== STATE VARIABLES =====
    address public owner;
    address public admin;
    address public verifier;
    
    // ===== MAPPINGS FOR ACCESS CONTROL =====
    mapping(address => bool) public authorizedUsers;
    mapping(address => bool) public farmOwners;
    mapping(address => bool) public productVerifiers;
    
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
        ProductStatus status,
        uint256 timestamp
    );
    event CategoryAdded(string indexed categoryName, string indexed userId, uint256 timestamp);
    event FarmUpdated(string indexed farmCode, address indexed updater, uint256 timestamp);
    event ProductUpdated(string indexed productCode, address indexed updater, uint256 timestamp);
    event FarmStatusChanged(string indexed farmCode, FarmStatus oldStatus, FarmStatus newStatus, uint256 timestamp);
    event ProductStatusChanged(string indexed productCode, ProductStatus oldStatus, ProductStatus newStatus, uint256 timestamp);
    event UserAuthorized(address indexed user, address indexed authorizer, uint256 timestamp);
    event UserDeauthorized(address indexed user, address indexed authorizer, uint256 timestamp);
    
    // Process Events
    event FarmingProcessAdded(string indexed productCode, address indexed creator, uint256 timestamp);
    event MedicineAdded(string indexed productCode, address indexed creator, uint256 timestamp);
    event FertilizerAdded(string indexed productCode, address indexed creator, uint256 timestamp);
    event HarvestAdded(string indexed productCode, address indexed creator, uint256 timestamp);
    event DistributionAdded(string indexed productCode, address indexed creator, uint256 timestamp);
    
    event FarmingProcessUpdated(string indexed productCode, address indexed updater, uint256 timestamp);
    event MedicineUpdated(string indexed productCode, address indexed updater, uint256 timestamp);
    event FertilizerUpdated(string indexed productCode, address indexed updater, uint256 timestamp);
    event HarvestUpdated(string indexed productCode, address indexed updater, uint256 timestamp);
    event DistributionUpdated(string indexed productCode, address indexed updater, uint256 timestamp);

    // ===== MODIFIERS =====
    
    /**
     * @notice Restricts access to contract owner only
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "AccessControl: Only owner allowed");
        _;
    }
    
    /**
     * @notice Restricts access to admin or owner
     */
    modifier onlyAdmin() {
        require(msg.sender == admin || msg.sender == owner, "AccessControl: Only admin allowed");
        _;
    }
    
    /**
     * @notice Restricts access to authorized users
     */
    modifier onlyAuthorized() {
        require(authorizedUsers[msg.sender] || msg.sender == owner, "AccessControl: Not authorized");
        _;
    }
    
    /**
     * @notice Ensures farm exists
     * @param _farmCode Farm identifier
     */
    modifier farmExists(string memory _farmCode) {
        require(farmCodeExists[_farmCode], "FarmManagement: Farm not found");
        _;
    }
    
    /**
     * @notice Ensures product exists
     * @param _productCode Product identifier
     */
    modifier productExists(string memory _productCode) {
        require(productCodeExists[_productCode], "ProductManagement: Product not found");
        _;
    }
    
    /**
     * @notice Validates farm area
     * @param _area Farm area in square meters
     */
    modifier validArea(uint256 _area) {
        require(_area >= MIN_AREA && _area <= MAX_AREA, "Validation: Invalid area");
        _;
    }
    
    /**
     * @notice Validates image count
     * @param _imageCount Number of images
     */
    modifier validImageCount(uint256 _imageCount) {
        require(_imageCount <= MAX_IMAGES, "Validation: Too many images");
        _;
    }

    // ===== CONSTRUCTOR =====
    
    /**
     * @notice Initializes the Agricultural Traceability System
     * @dev Sets up initial roles and state variables
     */
    constructor() {
        owner = msg.sender;
        admin = msg.sender;
        verifier = msg.sender;
        
        farmCount = 0;
        productCount = 0;
        
        // Authorize deployer as initial user
        authorizedUsers[msg.sender] = true;
        farmOwners[msg.sender] = true;
        productVerifiers[msg.sender] = true;
    }

    // ===== ACCESS CONTROL FUNCTIONS =====
    
    /**
     * @notice Authorizes a user to interact with the system
     * @param _user Address of user to authorize
     */
    function authorizeUser(address _user) external onlyAdmin {
        require(_user != address(0), "AccessControl: Invalid address");
        authorizedUsers[_user] = true;
        emit UserAuthorized(_user, msg.sender, block.timestamp);
    }
    
    /**
     * @notice Deauthorizes a user
     * @param _user Address of user to deauthorize
     */
    function deauthorizeUser(address _user) external onlyAdmin {
        require(_user != address(0), "AccessControl: Invalid address");
        authorizedUsers[_user] = false;
        emit UserDeauthorized(_user, msg.sender, block.timestamp);
    }
    
    /**
     * @notice Sets farm owner status
     * @param _user Address of user
     * @param _isOwner Whether user can own farms
     */
    function setFarmOwner(address _user, bool _isOwner) external onlyAdmin {
        require(_user != address(0), "AccessControl: Invalid address");
        farmOwners[_user] = _isOwner;
    }
    
    /**
     * @notice Sets product verifier status
     * @param _user Address of user
     * @param _isVerifier Whether user can verify products
     */
    function setProductVerifier(address _user, bool _isVerifier) external onlyAdmin {
        require(_user != address(0), "AccessControl: Invalid address");
        productVerifiers[_user] = _isVerifier;
    }
    
    /**
     * @notice Updates admin address
     * @param _newAdmin New admin address
     */
    function updateAdmin(address _newAdmin) external onlyOwner {
        require(_newAdmin != address(0), "AccessControl: Invalid address");
        admin = _newAdmin;
    }
    
    /**
     * @notice Updates verifier address
     * @param _newVerifier New verifier address
     */
    function updateVerifier(address _newVerifier) external onlyOwner {
        require(_newVerifier != address(0), "AccessControl: Invalid address");
        verifier = _newVerifier;
    }

    // ===== FARM MANAGEMENT FUNCTIONS =====
    
    /**
     * @notice Registers a new farm
     * @param _farmCode Unique farm identifier
     * @param _fullname Full name of farm owner
     * @param _nameFarm Farm name
     * @param _userId User identifier
     * @param _email Contact email
     * @param _phone Contact phone number
     * @param _description Farm description
     * @param _location Farm location
     * @param _area Farm area in square meters
     * @param _images Array of farm images
     */
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
    ) external onlyAuthorized validArea(_area) validImageCount(_images.length) {
        require(bytes(_farmCode).length > 0, "Validation: Empty farmCode");
        require(bytes(_fullname).length > 0, "Validation: Empty fullname");
        require(bytes(_nameFarm).length > 0, "Validation: Empty nameFarm");
        require(bytes(_userId).length > 0, "Validation: Empty userId");
        require(!farmCodeExists[_farmCode], "Validation: Farm already exists");

        userFarms[_userId].push(_farmCode);
        allFarmCodes.push(_farmCode);
        farmCodeExists[_farmCode] = true;
        farmCount++;
        
        farms[_farmCode] = Farm({
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

    //Hàm cập nhật trang trại
    function updateFarm(
        string memory _farmCode,
        string memory _nameFarm,
        string memory _description,
        string memory _location,
        uint256 _area,
        string[] memory _images
    ) external farmExists(_farmCode) validArea(_area) {
        Farm storage farm = farms[_farmCode];
        require(farm.isActive, "Farm inactive"); //trang trại không hoạt động
        
        if (bytes(_nameFarm).length > 0) farm.nameFarm = _nameFarm; //cập nhật tên trang trại
        if (bytes(_description).length > 0) farm.description = _description; //cập nhật mô tả trang trại
        if (bytes(_location).length > 0) farm.location = _location; //cập nhật vị trí trang trại
        if (_area > 0) farm.area = _area; //cập nhật diện tích trang trại
        if (_images.length > 0) farm.images = _images; //cập nhật ảnh trang trại
        
        emit FarmUpdated(_farmCode, msg.sender, block.timestamp);
    }

    //Hàm xóa trang trại
    function deactivateFarm(string memory _farmCode) external farmExists(_farmCode) {
        Farm storage farm = farms[_farmCode];
        require(farm.isActive, "Farm inactive"); //trang trại không hoạt động
        farm.isActive = false; //cập nhật trạng thái trang trại
    }

    //Hàm thêm sản phẩm
    function addProduct(ProductInput memory _productData) external {
        require(bytes(_productData.productCode).length > 0, "Empty productCode"); //mã sản phẩm không được để trống
        require(bytes(_productData.name).length > 0, "Empty name"); //tên sản phẩm không được để trống
        require(!productCodeExists[_productData.productCode], "Product exists"); //sản phẩm đã tồn tại
        require(farmCodeExists[_productData.farmCode], "Farm not found"); //trang trại không tồn tại

        farmProducts[_productData.farmCode].push(_productData.productCode); //thêm sản phẩm vào mapping trang trại
        allProductCodes.push(_productData.productCode); //thêm sản phẩm vào mảng
        productCodeExists[_productData.productCode] = true; //thêm sản phẩm vào mapping mã sản phẩm
        productCount++; //tăng số lượng sản phẩm
        
        products[_productData.productCode] = Product({
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
            status: ProductStatus.ACTIVE,
            certificationLevel: _productData.certificationLevel
        });

        emit ProductAdded(_productData.farmCode, _productData.productCode, _productData.categoryName, ProductStatus.ACTIVE, block.timestamp);
    }

    //Hàm cập nhật sản phẩm
    function updateProduct(
        string memory _productCode,
        string memory _name,
        string memory _quantity,
        string memory _price,
        string memory _description,
        string memory _image,
        string memory _batchCode,
        string memory _certification
    ) external productExists(_productCode) {
        Product storage product = products[_productCode];
        require(product.status == ProductStatus.ACTIVE, "Product inactive"); //sản phẩm không hoạt động
        
        if (bytes(_name).length > 0) product.name = _name; //cập nhật tên sản phẩm
        if (bytes(_quantity).length > 0) product.quantity = _quantity; //cập nhật số lượng sản phẩm
        if (bytes(_price).length > 0) product.price = _price; //cập nhật giá sản phẩm
        if (bytes(_description).length > 0) product.description = _description; //cập nhật mô tả sản phẩm
        if (bytes(_image).length > 0) product.image = _image; //cập nhật ảnh sản phẩm
        if (bytes(_batchCode).length > 0) product.batchCode = _batchCode; //cập nhật mã lô
        if (bytes(_certification).length > 0) product.certification = _certification; //cập nhật chứng nhận
        
        emit ProductUpdated(_productCode, msg.sender, block.timestamp); //emit sự kiện sản phẩm đã được cập nhật
    }

    //Hàm xóa sản phẩm
    function deactivateProduct(string memory _productCode) external productExists(_productCode) {
        Product storage product = products[_productCode];
        require(product.status == ProductStatus.ACTIVE, "Product inactive"); //sản phẩm không hoạt động
        ProductStatus oldStatus = product.status;
        product.status = ProductStatus.INACTIVE; //cập nhật trạng thái sản phẩm
        emit ProductStatusChanged(_productCode, oldStatus, ProductStatus.INACTIVE, block.timestamp);
    }

    //Hàm thêm loại sản phẩm
    function addCategory(string memory _categoryName, string memory _userId) external {
        require(bytes(_categoryName).length > 0, "Empty category name"); //loại sản phẩm không được để trống
        require(bytes(_userId).length > 0, "Empty userId"); //mã người dùng không được để trống
        
        if (!categoryExists[_categoryName]) {
            categoryExists[_categoryName] = true; //thêm loại sản phẩm vào mapping loại sản phẩm
            allCategories.push(_categoryName); //thêm loại sản phẩm vào mảng
        }
        
        userCategories[_userId].push(_categoryName); //thêm loại sản phẩm vào mapping người dùng
        emit CategoryAdded(_categoryName, _userId, block.timestamp); //emit sự kiện loại sản phẩm đã được thêm
    }

    //Hàm thêm ảnh trang trại
    function addFarmImage(string memory _farmCode, string memory _imageUrl) external farmExists(_farmCode) {
        Farm storage farm = farms[_farmCode];
        require(farm.isActive, "Farm inactive"); //trang trại không hoạt động
        farm.images.push(_imageUrl); //thêm ảnh trang trại
    }

    //Hàm xóa ảnh trang trại
    function removeFarmImage(string memory _farmCode, uint256 _imageIndex) external farmExists(_farmCode) {
        Farm storage farm = farms[_farmCode];
        require(farm.isActive, "Farm inactive"); //trang trại không hoạt động
        require(_imageIndex < farm.images.length, "Invalid image index"); //ảnh không tồn tại
        
        for (uint i = _imageIndex; i < farm.images.length - 1; i++) {
            farm.images[i] = farm.images[i + 1]; //cập nhật ảnh trang trại
        }
        farm.images.pop(); //xóa ảnh trang trại
    }

    // ===== AGRICULTURAL PROCESS FUNCTIONS =====
    
    //Hàm thêm quy trình canh tác
    function addFarmingProcess(
        string memory _productCode,
        string memory _nameProcess,
        string memory _source,
        string memory _plantingDate,
        string memory _sowingDate
    ) external productExists(_productCode) {
        require(bytes(_nameProcess).length > 0, "Empty process name"); //tên quy trình không được để trống
        require(bytes(_plantingDate).length > 0, "Empty planting date"); //ngày trồng không được để trống
        require(products[_productCode].status == ProductStatus.ACTIVE, "Product inactive"); //sản phẩm không hoạt động
        
        farmingProcesses[_productCode] = FarmingProcess({
            productCode: _productCode,
            nameProcess: _nameProcess,
            source: _source,
            plantingDate: _plantingDate,
            sowingDate: _sowingDate,
            createdAt: block.timestamp
        });

        emit FarmingProcessAdded(_productCode, msg.sender, block.timestamp);
    }

    //Hàm cập nhật quy trình canh tác
    function updateFarmingProcess(
        string memory _productCode,
        string memory _nameProcess,
        string memory _source,
        string memory _plantingDate,
        string memory _sowingDate
    ) external productExists(_productCode) {
        require(products[_productCode].status == ProductStatus.ACTIVE, "Product inactive");
        FarmingProcess storage process = farmingProcesses[_productCode];
        
        if (bytes(_nameProcess).length > 0) process.nameProcess = _nameProcess;
        if (bytes(_source).length > 0) process.source = _source;
        if (bytes(_plantingDate).length > 0) process.plantingDate = _plantingDate;
        if (bytes(_sowingDate).length > 0) process.sowingDate = _sowingDate;
        
        emit FarmingProcessUpdated(_productCode, msg.sender, block.timestamp);
    }

    //Hàm thêm thuốc bảo vệ thực vật
    function addMedicine(
        string memory _productCode,
        string memory _nameMedicine,
        string memory _quantityMedicine,
        string memory _medicineDate,
        string memory _medicineType,
        string memory _applicationMethod
    ) external productExists(_productCode) {
        require(bytes(_nameMedicine).length > 0, "Empty medicine name"); //tên thuốc không được để trống
        require(bytes(_medicineDate).length > 0, "Empty medicine date"); //ngày dùng thuốc không được để trống
        require(products[_productCode].status == ProductStatus.ACTIVE, "Product inactive"); //sản phẩm không hoạt động
        
        medicines[_productCode] = Medicine({
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

    //Hàm cập nhật thuốc bảo vệ thực vật
    function updateMedicine(
        string memory _productCode,
        string memory _nameMedicine,
        string memory _quantityMedicine,
        string memory _medicineDate,
        string memory _medicineType,
        string memory _applicationMethod
    ) external productExists(_productCode) {
        require(products[_productCode].status == ProductStatus.ACTIVE, "Product inactive");
        Medicine storage medicine = medicines[_productCode];
        
        if (bytes(_nameMedicine).length > 0) medicine.nameMedicine = _nameMedicine;
        if (bytes(_quantityMedicine).length > 0) medicine.quantityMedicine = _quantityMedicine;
        if (bytes(_medicineDate).length > 0) medicine.medicineDate = _medicineDate;
        if (bytes(_medicineType).length > 0) medicine.medicineType = _medicineType;
        if (bytes(_applicationMethod).length > 0) medicine.applicationMethod = _applicationMethod;
        
        emit MedicineUpdated(_productCode, msg.sender, block.timestamp);
    }

    //Hàm thêm phân bón
    function addFertilizer(
        string memory _productCode,
        string memory _nameFertilizer,
        string memory _quantityFertilizer,
        string memory _fertilizerDate,
        string memory _fertilizerType,
        string memory _applicationMethod,
        string memory _expectedEffect
    ) external productExists(_productCode) {
        require(bytes(_nameFertilizer).length > 0, "Empty fertilizer name"); //tên phân bón không được để trống
        require(bytes(_fertilizerDate).length > 0, "Empty fertilizer date"); //ngày bón phân không được để trống
        require(products[_productCode].status == ProductStatus.ACTIVE, "Product inactive"); //sản phẩm không hoạt động
        
        fertilizers[_productCode] = Fertilizer({
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

    //Hàm cập nhật phân bón
    function updateFertilizer(
        string memory _productCode,
        string memory _nameFertilizer,
        string memory _quantityFertilizer,
        string memory _fertilizerDate,
        string memory _fertilizerType,
        string memory _applicationMethod,
        string memory _expectedEffect
    ) external productExists(_productCode) {
        require(products[_productCode].status == ProductStatus.ACTIVE, "Product inactive");
        Fertilizer storage fertilizer = fertilizers[_productCode];
        
        if (bytes(_nameFertilizer).length > 0) fertilizer.nameFertilizer = _nameFertilizer;
        if (bytes(_quantityFertilizer).length > 0) fertilizer.quantityFertilizer = _quantityFertilizer;
        if (bytes(_fertilizerDate).length > 0) fertilizer.fertilizerDate = _fertilizerDate;
        if (bytes(_fertilizerType).length > 0) fertilizer.fertilizerType = _fertilizerType;
        if (bytes(_applicationMethod).length > 0) fertilizer.applicationMethod = _applicationMethod;
        if (bytes(_expectedEffect).length > 0) fertilizer.expectedEffect = _expectedEffect;
        
        emit FertilizerUpdated(_productCode, msg.sender, block.timestamp);
    }

    //Hàm thêm thông tin thu hoạch
    function addHarvest(
        string memory _productCode,
        string memory _harvestDate,
        string memory _estimatedQuantity,
        string memory _actualQuantity,
        string memory _quality,
        string memory _harvestMethod
    ) external productExists(_productCode) {
        require(bytes(_harvestDate).length > 0, "Empty harvest date"); //ngày thu hoạch không được để trống
        require(products[_productCode].status == ProductStatus.ACTIVE, "Product inactive"); //sản phẩm không hoạt động
        
        harvests[_productCode] = Harvest({
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

    //Hàm cập nhật thông tin thu hoạch
    function updateHarvest(
        string memory _productCode,
        string memory _harvestDate,
        string memory _estimatedQuantity,
        string memory _actualQuantity,
        string memory _quality,
        string memory _harvestMethod
    ) external productExists(_productCode) {
        require(products[_productCode].status == ProductStatus.ACTIVE, "Product inactive");
        Harvest storage harvest = harvests[_productCode];
        
        if (bytes(_harvestDate).length > 0) harvest.harvestDate = _harvestDate;
        if (bytes(_estimatedQuantity).length > 0) harvest.estimatedQuantity = _estimatedQuantity;
        if (bytes(_actualQuantity).length > 0) harvest.actualQuantity = _actualQuantity;
        if (bytes(_quality).length > 0) harvest.quality = _quality;
        if (bytes(_harvestMethod).length > 0) harvest.harvestMethod = _harvestMethod;
        
        emit HarvestUpdated(_productCode, msg.sender, block.timestamp);
    }

    //Hàm thêm thông tin phân phối
    function addDistribution(
        string memory _productCode,
        string memory _distributorName,
        string memory _distributorPartner,
        string memory _distributionDate,
        string memory _transportMethod,
        string memory _storageConditions
    ) external productExists(_productCode) {
        require(bytes(_distributorName).length > 0, "Empty distributor name"); //tên nhà phân phối không được để trống
        require(bytes(_distributionDate).length > 0, "Empty distribution date"); //ngày phân phối không được để trống
        require(products[_productCode].status == ProductStatus.ACTIVE, "Product inactive"); //sản phẩm không hoạt động
        
        distributions[_productCode] = Distribution({
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

    //Hàm cập nhật thông tin phân phối
    function updateDistribution(
        string memory _productCode,
        string memory _distributorName,
        string memory _distributorPartner,
        string memory _distributionDate,
        string memory _transportMethod,
        string memory _storageConditions
    ) external productExists(_productCode) {
        require(products[_productCode].status == ProductStatus.ACTIVE, "Product inactive");
        Distribution storage distribution = distributions[_productCode];
        
        if (bytes(_distributorName).length > 0) distribution.distributorName = _distributorName;
        if (bytes(_distributorPartner).length > 0) distribution.distributorPartner = _distributorPartner;
        if (bytes(_distributionDate).length > 0) distribution.distributionDate = _distributionDate;
        if (bytes(_transportMethod).length > 0) distribution.transportMethod = _transportMethod;
        if (bytes(_storageConditions).length > 0) distribution.storageConditions = _storageConditions;
        
        emit DistributionUpdated(_productCode, msg.sender, block.timestamp);
    }

    // ===== GETTER FUNCTIONS =====
    //Hàm lấy trang trại
    function getFarm(string memory _farmCode) external view farmExists(_farmCode) returns (Farm memory) {
        return farms[_farmCode]; //lấy trang trại   
    }

    //Hàm lấy sản phẩm
    function getProduct(string memory _productCode) external view productExists(_productCode) returns (Product memory) {
        return products[_productCode]; //lấy sản phẩm
    }

    //Hàm lấy quy trình canh tác
    function getFarmingProcess(string memory _productCode) external view productExists(_productCode) returns (FarmingProcess memory) {
        return farmingProcesses[_productCode]; //lấy quy trình canh tác
    }

    //Hàm lấy thông tin thuốc bảo vệ thực vật
    function getMedicine(string memory _productCode) external view productExists(_productCode) returns (Medicine memory) {
        return medicines[_productCode]; //lấy thông tin thuốc
    }

    //Hàm lấy thông tin phân bón
    function getFertilizer(string memory _productCode) external view productExists(_productCode) returns (Fertilizer memory) {
        return fertilizers[_productCode]; //lấy thông tin phân bón
    }

    //Hàm lấy thông tin thu hoạch
    function getHarvest(string memory _productCode) external view productExists(_productCode) returns (Harvest memory) {
        return harvests[_productCode]; //lấy thông tin thu hoạch
    }

    //Hàm lấy thông tin phân phối
    function getDistribution(string memory _productCode) external view productExists(_productCode) returns (Distribution memory) {
        return distributions[_productCode]; //lấy thông tin phân phối
    }

    //Hàm lấy toàn bộ thông tin truy xuất sản phẩm
    function getCompleteProductTraceability(string memory _productCode) 
        external 
        view 
        productExists(_productCode) 
        returns (
            Product memory product,
            FarmingProcess memory farmingProcess,
            Medicine memory medicine,
            Fertilizer memory fertilizer,
            Harvest memory harvest,
            Distribution memory distribution
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

    //Hàm lấy tất cả trang trại
    function getAllFarms() external view returns (Farm[] memory) {
        Farm[] memory allFarms = new Farm[](allFarmCodes.length); //tạo mảng trang trại
        for (uint i = 0; i < allFarmCodes.length; i++) {
            allFarms[i] = farms[allFarmCodes[i]]; //lấy trang trại
        }
        return allFarms; //trả về mảng trang trại
    }

    //Hàm lấy trang trại của người dùng
    function getFarmsByUserId(string memory _userId) external view returns (Farm[] memory) {
        string[] memory userFarmCodes = userFarms[_userId];
        require(userFarmCodes.length > 0, "User not found"); //người dùng không tồn tại
        
        Farm[] memory userFarmsArray = new Farm[](userFarmCodes.length); //tạo mảng trang trại
        for (uint i = 0; i < userFarmCodes.length; i++) {
            userFarmsArray[i] = farms[userFarmCodes[i]]; //lấy trang trại
        }
        return userFarmsArray; //trả về mảng trang trại
    }

    //Hàm lấy sản phẩm của trang trại
    function getProductsByFarm(string memory _farmCode) external view farmExists(_farmCode) returns (Product[] memory) {
        string[] memory productCodes = farmProducts[_farmCode];
        Product[] memory farmProductsArray = new Product[](productCodes.length); //tạo mảng sản phẩm
        for (uint i = 0; i < productCodes.length; i++) {
            farmProductsArray[i] = products[productCodes[i]]; //lấy sản phẩm
        }
        return farmProductsArray; //trả về mảng sản phẩm
    }

    //Hàm lấy ảnh trang trại
    function getFarmImages(string memory _farmCode) external view farmExists(_farmCode) returns (string[] memory) {
        return farms[_farmCode].images; //lấy ảnh trang trại
    }

    //Hàm lấy tất cả loại sản phẩm
    function GetAllCategories() external view returns (string[] memory) {
        return allCategories; //lấy tất cả loại sản phẩm
    }

    //Hàm lấy loại sản phẩm của người dùng
    function GetAllCategoryuserId(string memory _userId) external view returns (string[] memory) {
        return userCategories[_userId]; //lấy loại sản phẩm của người dùng
    }

    //Hàm kiểm tra loại sản phẩm có tồn tại không
    function categoryExistsCheck(string memory _categoryName) external view returns (bool) {
        return categoryExists[_categoryName]; //kiểm tra loại sản phẩm có tồn tại không
    }

    //Hàm kiểm tra người dùng có trang trại không
    function userExists(string memory _userId) external view returns (bool) {
        return userFarms[_userId].length > 0; //kiểm tra người dùng có trang trại không
    }

    //Hàm lấy số lượng trang trại
    function getTotalFarms() external view returns (uint256) {
        return farmCount; //lấy số lượng trang trại
    }

    //Hàm lấy số lượng sản phẩm
    function getTotalProducts() external view returns (uint256) {
        return productCount; //lấy số lượng sản phẩm
    }
}