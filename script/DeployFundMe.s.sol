// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.sol";

contract DeployFundeMe is Script {

    function run() external returns (FundMe) {

        HelperConfig helperConfig = new HelperConfig();
        address ethPricefeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        //Mock 
        FundMe fundMe = new FundMe(ethPricefeed);
        vm.stopBroadcast();
        return fundMe;
    }


}