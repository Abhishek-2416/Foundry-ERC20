// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public token;
    DeployOurToken public deployer;

    //addresses
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() external {
        deployer = new DeployOurToken();
        token = deployer.run();

        vm.prank(msg.sender);
        token.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() external {
        assertEq(address(bob).balance, STARTING_BALANCE);
    }

    // function testTheNameIsCorrect() external {
    //     string memory actualName = token.name();
    //     string memory expectedName = "OurToken";
    //     assertEq(keccak256(abi.encode(actualName)), keccak256(abi.encode(expectedName)));
    // }
}
