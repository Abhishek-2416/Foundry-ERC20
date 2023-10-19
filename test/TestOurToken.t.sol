// SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {Test,console} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.sol";

contract testOurToken is Test{
    OurToken public token;
    DeployOurToken public deployer;

    //Making test addresses
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant TRANSFER_BALANCE = 10 ether;
    
    function setUp() public{
        deployer = new DeployOurToken();
        token = deployer.run();

        //Providing bob with a starting balance
        vm.prank(msg.sender);
        token.transfer(bob,STARTING_BALANCE);
    }

    ////////////////////
    // Basic Testing //
    ///////////////////

    function testNameOfToken() public{
        assertEq(token.name(),"Bitcoin");
    }

    function testSymbolOfToken() public{
        assertEq(token.symbol(),"BTC");
    }

    function testTransfer() public{
        vm.prank(bob);
        token.transfer(alice, TRANSFER_BALANCE);
        assertEq(token.balanceOf(bob),STARTING_BALANCE-TRANSFER_BALANCE);
        assertEq(token.balanceOf(alice),TRANSFER_BALANCE);
    }

    function testBurn() public{
        vm.prank(bob);
        token.transfer(alice,TRANSFER_BALANCE);
        assertEq(token.balanceOf(bob),STARTING_BALANCE- TRANSFER_BALANCE);

        vm.prank(msg.sender);
        token.burn(alice,TRANSFER_BALANCE);

        assertEq(token.balanceOf(alice),0);
    }

    function testApprove() public{
        vm.prank(bob);
        token.approve(alice,TRANSFER_BALANCE);
        uint256 currentAllowance = token.allowance(bob,alice);
        assertEq(currentAllowance,TRANSFER_BALANCE);
    }

    function testTransferFrom() public{
        vm.prank(bob);
        token.approve(alice,TRANSFER_BALANCE);
        uint256 currentAllowance = token.allowance(bob,alice);
        assertEq(currentAllowance,TRANSFER_BALANCE);

        vm.prank(alice);
        token.transferFrom(bob,alice,TRANSFER_BALANCE);
        assertEq(token.balanceOf(alice),TRANSFER_BALANCE);
        assertEq(token.balanceOf(bob),STARTING_BALANCE-TRANSFER_BALANCE);
    }
    
}