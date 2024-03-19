// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract TestOurToken is Test {
    OurToken ourToken;

    //addresses
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        DeployOurToken deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.deal(bob, STARTING_BALANCE);
    }

    function testBobStartingBalance() public view {
        assertEq(address(bob).balance, STARTING_BALANCE);
    }

    function testNameOfToken() public view {
        string memory actualName = ourToken.name();
        string memory expectedName = "OurToken";

        assertEq(keccak256(abi.encodePacked(actualName)), keccak256(abi.encodePacked(expectedName)));
    }

    function testSymbolOfToken() public view {
        string memory actualSymbol = ourToken.symbol();
        string memory expectedSymbol = "OT";

        assertEq(keccak256(abi.encodePacked(actualSymbol)), keccak256(abi.encodePacked(expectedSymbol)));
    }
}
