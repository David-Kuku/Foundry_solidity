// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import {Script} from 'forge-std/Script.sol';
import {FundMe} from '../src/FundMe.sol';
import {HelperConfig} from './HelperConfig.s.sol';

contract DeployFundMe is Script{
    function run() external returns (FundMe){
        // anything before startbroadcast is not treated as a real transaction
        // hence no gas is spent, that's why we do the helperconfig before vm.startbroadcast.

        HelperConfig helperConfig = new HelperConfig();
        (address ethUsdPriceFeed_address) = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundme = new FundMe(ethUsdPriceFeed_address);
        vm.stopBroadcast();
        return fundme;
    }
}