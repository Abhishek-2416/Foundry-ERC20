// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant INITAL_SUPPLY = 1000 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
    }

    //Test bobs balance
    function testBobBalance() public {
        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    //Test the inital balance of the owner
    function testIntialOwnerBalance() public {
        assertEq(ourToken.balanceOf(msg.sender), INITAL_SUPPLY);
    }
}
