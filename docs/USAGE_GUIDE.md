# Hướng Dẫn Sử Dụng TruyXuat

## 🎯 Tổng Quan
Smart contract quản lý nông trại và nông sản. Đơn giản, dễ hiểu.

## 🚀 Cài Đặt

```bash
# Cài đặt
npm install

# Compile
npx hardhat compile

# Test
npx hardhat test

# Deploy
npx hardhat run scripts/deploy.js --network hardhat
```

## 📝 Cách Dùng

### 1. Đăng Ký Nông Trại

```javascript
await truyXuat.registerFarm(
    "FARM001",                    // Mã nông trại
    "Nguyen Van A",              // Họ tên chủ
    "Nong Trai Xanh",            // Tên nông trại
    "USER001",                    // Mã người dùng
    "nguyenvana@email.com",      // Email
    "0123456789",                // Số điện thoại
    "Nông trại rau sạch",        // Mô tả
    "Hanoi, Vietnam",            // Địa chỉ
    1000,                        // Diện tích (m2)
    ["farm1.jpg", "farm2.jpg"]   // Hình ảnh
);
```

### 2. Thêm Sản Phẩm

```javascript
const productData = {
  farmCode: "FARM001",
    productCode: "PROD001",
    categoryName: "Rau Xanh",
    name: "Rau Cải Xanh",
    quantity: "100kg",
    price: "50000 VND/kg",
    description: "Rau cải xanh tươi ngon",
    image: "raucai.jpg",
    nameProcess: "Canh tác hữu cơ",
    source: "Hạt giống Việt Nam",
    plantingDate: "2024-01-15",
    nameMedicine: "Thuốc trừ sâu sinh học",
    quantityMedicine: "50ml",
    MedicineDate: "2024-01-20",
    nameFertilizer: "Phân hữu cơ",
    quantityFertilizer: "10kg",
    fertilizerType: "Phân chuồng",
    FertilizerDay: "2024-01-10",
    nameDistribution: "Công ty ABC",
    sowingDate: "2024-01-15",
    harvestDate: "2024-03-15",
    batchCode: "BATCH001",
    certification: "VietGAP",
    distributorPartner: "Siêu thị XYZ"
};

await truyXuat.addProduct(productData);
```

### 3. Thêm Danh Mục

```javascript
await truyXuat.addCategory("Rau Xanh", "USER001");
await truyXuat.addCategory("Trái Cây", "USER001");
```

### 4. Quản Lý Hình Ảnh

```javascript
// Thêm hình ảnh
await truyXuat.addFarmImage("FARM001", "farm3.jpg");

// Xóa hình ảnh (index 0)
await truyXuat.removeFarmImage("FARM001", 0);

// Xem tất cả hình ảnh
const images = await truyXuat.getFarmImages("FARM001");
```

### 5. Cập Nhật Thông Tin

```javascript
// Cập nhật nông trại
await truyXuat.updateFarm(
    "FARM001",
    "Nong Trai Xanh Moi",       // Tên mới
    "Mô tả mới",                // Mô tả mới
    "Hanoi, Vietnam",            // Địa chỉ mới
    1200,                        // Diện tích mới
    ["new1.jpg", "new2.jpg"]     // Hình ảnh mới
);

// Cập nhật sản phẩm
await truyXuat.updateProduct(
    "PROD001",
    "Rau Cải Xanh Moi",          // Tên mới
    "150kg",                     // Số lượng mới
    "60000 VND/kg",              // Giá mới
    "Mô tả mới",                 // Mô tả mới
    "newrau.jpg"                 // Hình ảnh mới
);
```

## 🔍 Xem Thông Tin

### Nông Trại
```javascript
// Xem 1 nông trại
const farm = await truyXuat.getFarm("FARM001");

// Xem tất cả nông trại
const allFarms = await truyXuat.getAllFarms();

// Xem nông trại theo user
const userFarms = await truyXuat.getFarmsByUserId("USER001");
```

### Sản Phẩm
```javascript
// Xem 1 sản phẩm
const product = await truyXuat.getProduct("PROD001");

// Xem sản phẩm theo nông trại
const farmProducts = await truyXuat.getProductsByFarm("FARM001");
```

### Danh Mục
```javascript
// Xem tất cả danh mục
const allCategories = await truyXuat.GetAllCategories();

// Xem danh mục theo user
const userCategories = await truyXuat.GetAllCategoryuserId("USER001");

// Kiểm tra danh mục có tồn tại
const exists = await truyXuat.categoryExistsCheck("Rau Xanh");
```

### Thống Kê
```javascript
// Tổng số nông trại
const totalFarms = await truyXuat.getTotalFarms();

// Tổng số sản phẩm
const totalProducts = await truyXuat.getTotalProducts();

// Kiểm tra user có tồn tại
const userExists = await truyXuat.userExists("USER001");
```

## ⚠️ Lưu Ý

1. **Mã phải duy nhất**: farmCode và productCode không được trùng
2. **Diện tích**: Tối đa 1,000,000 m2
3. **Trường bắt buộc**: farmCode, fullname, nameFarm, userId, name
4. **Trạng thái**: Chỉ nông trại/sản phẩm active mới có thể cập nhật

## 🚫 Xử Lý Lỗi

```javascript
try {
    await truyXuat.registerFarm(...);
} catch (error) {
  if (error.message.includes("Farm exists")) {
        console.log("Mã nông trại đã tồn tại");
    } else if (error.message.includes("Empty")) {
        console.log("Thiếu thông tin bắt buộc");
  } else if (error.message.includes("Invalid area")) {
        console.log("Diện tích không hợp lệ");
  }
}
```

