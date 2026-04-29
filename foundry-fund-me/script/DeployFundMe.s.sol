// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    function run() external {
        vm.startBroadcast();
        new FundMe();
        console.log("FundMe deployed!");
        console.log("FundMe address:", address(new FundMe()));
        vm.stopBroadcast();
    }
}
