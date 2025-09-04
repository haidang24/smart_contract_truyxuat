require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1, // Optimized for deployment size
      },
    },
  },
  paths: {
    sources: "./src/contracts",
    tests: "./src/test",
    cache: "./build/cache",
    artifacts: "./build/artifacts"
  },

  networks: {
    hardhat: {
      chainId: 1337,
    },
    zeroscan: {
      url: "https://rpc.zeroscan.org",
      accounts: [
        "0xc85073f0cc081b1186714b15f21d302b4c7de5022336dad6a4ca3a413fcf5cd3",
      ],
      chainId: 5080,
    },
  },
  etherscan: {
    apiKey: {
      zeroscan:
        "0x0000000000000000000000000000000000000000000000000000000000000000", // Đây là API key nếu explorer cung cấp
    },
    customChains: [
      {
        network: "zeroscan",
        chainId: 5080,
        urls: {
          apiURL: "https://zeroscan.org/api", // API xác minh
          browserURL: "https://zeroscan.org", // Trình duyệt Explorer
        },
      },
    ],
  },
};
