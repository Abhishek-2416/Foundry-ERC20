// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {ManualToken} from "../src/ManualToken.sol";

contract DeployManualToken is Script {
    ManualToken public manualToken;

    function setUp() external returns (ManualToken) {
        vm.startBroadcast();
        vm.stopBroadcast();
        return manualToken;
    }
}
