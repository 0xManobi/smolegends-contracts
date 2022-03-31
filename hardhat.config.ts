import { config as dotenv } from 'dotenv';
import { removeConsoleLog } from 'hardhat-preprocessor';
import { HardhatUserConfig } from 'hardhat/config';

import 'solidity-coverage';
import '@typechain/hardhat';
import 'hardhat-watcher';
import 'hardhat-abi-exporter';
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-waffle';
import 'hardhat-contract-sizer';
import 'hardhat-gas-reporter';
import 'hardhat-tracer';

// dotenv({ path: resolve(__dirname, './.env') });

const config: HardhatUserConfig = {
  defaultNetwork: 'hardhat',
  networks: {
    hardhat: {
      chainId: 1337,
    },
  },
  paths: {
    artifacts: './artifacts',
    cache: './cache',
    sources: './contracts',
    tests: './test',
  },
  solidity: {
    version: '0.8.9',
    settings: {
      // https://hardhat.org/hardhat-network/#solidity-optimizer-support
      // optimizer: {
      // enabled: true,
      // runs: 999999,
      // },
    },
  },
  typechain: {
    outDir: 'typechain',
    target: 'ethers-v5',
  },
  preprocess: {
    eachLine: removeConsoleLog(
      (bre) =>
        bre.network.name !== 'hardhat' && bre.network.name !== 'localhost',
    ),
  },
  watcher: {
    compile: {
      tasks: ['compile'],
      files: ['./contracts'],
      verbose: true,
    },
  },
  abiExporter: {
    path: './data/abi',
    clear: true,
    flat: true,
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
  },
  gasReporter: {
    enabled: false,
  },
  etherscan: {
    // apiKey: process.env.ETHERSCAN_API_KEY
  },
};

export default config;
