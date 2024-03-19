// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {ManualToken} from "../src/ManualToken.sol";

contract DeployManualToken is Script {
    uint256 constant INITAL_SUPPPLY = 1000 ether;

    function run() external returns (ManualToken) {
        vm.startBroadcast();
        ManualToken manualToken = new ManualToken(INITAL_SUPPPLY);
        vm.stopBroadcast();
        return manualToken;
    }
}
