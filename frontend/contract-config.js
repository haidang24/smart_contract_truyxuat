/**
 * Configuration for Agricultural Traceability System Smart Contract
 */

export const CONTRACT_CONFIG = {
  // Network Information
  network: {
    id: 5080,
    name: 'ZeroScan',
    rpcUrl: 'https://rpc.zeroscan.org',
    explorerUrl: 'https://zeroscan.org',
    nativeCurrency: { name: 'ETH', symbol: 'ETH', decimals: 18 }
  },

  // Contract Details
  contract: {
    address: '0x8F6c1F3bb7561988ef6F749874690aA2450b039E',
    name: 'AgriculturalTraceabilitySystem',
    verified: true
  },

  // Constants
  constants: {
    MAX_AREA: 1000000,
    MIN_AREA: 1,
    MAX_IMAGES: 10,
    MAX_QUANTITY: 1000000
  },

  // Enums
  enums: {
    ProductStatus: { ACTIVE: 0, INACTIVE: 1, RECALLED: 2, PENDING_VERIFICATION: 3 },
    CertificationLevel: { NONE: 0, BASIC: 1, ORGANIC: 2, PREMIUM: 3, CERTIFIED: 4 }
  }
};

// Helper Functions
export const formatAddress = (address) => {
  if (!address || typeof address !== 'string') return '';
  if (address.length < 10) return address;
  return `${address.slice(0, 6)}...${address.slice(-4)}`;
};

export const formatTimestamp = (timestamp) => {
  try {
    const date = new Date(Number(timestamp) * 1000);
    return date.toLocaleDateString('vi-VN', {
      year: 'numeric', month: 'long', day: 'numeric',
      hour: '2-digit', minute: '2-digit'
    });
  } catch {
    return 'Không xác định';
  }
};

export const getStatusText = (status, type = 'product') => {
  const statusMaps = {
    product: { 0: 'Hoạt động', 1: 'Không hoạt động', 2: 'Đã thu hồi', 3: 'Chờ xác minh' },
    farm: { 0: 'Hoạt động', 1: 'Không hoạt động', 2: 'Bị đình chỉ', 3: 'Chờ phê duyệt' }
  };
  return statusMaps[type]?.[status] || 'Không xác định';
};

export const getCertificationText = (level) => {
  const certMap = { 0: 'Không có', 1: 'Cơ bản', 2: 'Hữu cơ', 3: 'Cao cấp', 4: 'Chứng nhận đầy đủ' };
  return certMap[level] || 'Không xác định';
};

export default CONTRACT_CONFIG;
