// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from 'forge-std/Script.sol';
import {MockV3Aggregator} from '../test/mock/MockV3Aggregator.sol';

contract HelperConfig is Script {
    // if we're on a local anvil, we deploy mocks
    // else, we grab the existing address from the live network

    NetworkConfig public activeNetworkConfig;
    uint8 constant public DECIMALS = 8;
    int256 constant public INITIAL_PRICE = 2000e8;

    constructor() {
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }
    struct NetworkConfig {
        address priceFeed; // ETH/USD pricefeed address
    }
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if(activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }
        
        // deploy the mocks
        // return the mock address
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
        NetworkConfig memory anvilConfig = NetworkConfig(address(mockV3Aggregator));
        vm.stopBroadcast();
        return anvilConfig;
    }

}