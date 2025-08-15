// 1: Deploy mocks when we are on a local anvil chain
// 2: Keep track of contract addresses across different chains

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "test/mocks/MockV3Aggregator.t.sol";

contract HelperConfig is Script {
    //If we are on a local anvil chain, we will deploy mocks
    //Otherwise, grab the existing address from live networks

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000e8; // 2000

    struct NetworkConfig {
        address priceFeed;
    }
    NetworkConfig public activeNetworkConfig;

    // Constructor to set the active network config based on the chain ID
    constructor() {
        if (block.chainid == 11155111) {
            // Sepolia
            // Deploy mocks or set up the environment for Sepolia
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            // Mainnet
            // Use existing addresses for Mainnet
            activeNetworkConfig = getEthMainnetConfig();
        } else {
            // Anvil or other local test networks
            // Deploy mocks or set up the environment for Anvil
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    //function logic to get the active network config

    // function getActiveNetworkConfig()
    //     public
    //     view
    //     returns (NetworkConfig memory)
    // {
    //     if (block.chainid == 11155111) {
    //         // Sepolia
    //         return getSepoliaEthConfig();
    //     } else if (block.chainid == 1) {
    //         // Mainnet
    //         return getEthMainnetConfig();
    //     } else {
    //         getAnvilEthConfig();
    //         // This is a mock address for Anvil, you can replace it with your actual mock
    //     }
    //     revert("Network not supported");
    // }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Sepolia ETH/USD Price Feed Address
            });
    }

    function getEthMainnetConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 // Mock address for ETH/USD Price Feed on Mainnet // Mainnet ETH/USD Price Feed Address
            });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // return
        //     NetworkConfig({
        //         priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Mock address for ETH/USD Price Feed on Anvil
        //     });

        if (activeNetworkConfig.priceFeed != address(0)) {
            // If the price feed is already set, return the existing config
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(
            DECIMALS,
            INITIAL_ANSWER
        );
        vm.stopBroadcast();

        return
            NetworkConfig({
                priceFeed: address(mockV3Aggregator) // Mock address for ETH/USD Price Feed on Anvil
            });
    }
}
