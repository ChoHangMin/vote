module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
  },
  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/truffle_abis/',
  migrations_directory: './migrations/',
  tests_directory: './test/',
  compilers: {
    solc: {
      version: '^0.5.1',
      optimizer: {
        enabled: true,
        runs: 200
      },
    }
  }
}