// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/Test.sol";
import {ManualToken} from "../src/ManualToken.sol";
import {DeployManualToken} from "../script/DeployManualToken.t.sol";

contract TestManualToken is Test {
    ManualToken manualToken;

    //events
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);

    //address
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    //variables
    uint256 constant INITAL_SUPPLY = 100 ether;
    uint256 constant TOTAL_SUPPLY = 1000 ether;

    function setUp() external {
        DeployManualToken deployer = new DeployManualToken();
        manualToken = deployer.run();
    }

    function testTokenName() external view {
        string memory actualName = manualToken.getName();
        string memory expectedName = "Manual Token";

        assertEq(keccak256(abi.encodePacked(actualName)), keccak256(abi.encodePacked(expectedName)));
    }

    function testTokenSymbol() external view {
        string memory actualSymbol = manualToken.getSymbol();
        string memory expectedSymbol = "MT";

        assertEq(keccak256(abi.encodePacked(actualSymbol)), keccak256(abi.encodePacked(expectedSymbol)));
    }

    function testNumberOfDecimals() external view {
        uint256 actualNumberOfDecimals = manualToken.getDecimals();
        uint256 expectedNumberOfDecimals = 18;

        assertEq(actualNumberOfDecimals, expectedNumberOfDecimals);
    }

    function testTotalSupply() external view {
        uint256 actualTotalSupply = manualToken.getTotalSupply();
        uint256 expectedTotalSupply = 1000 ether;

        assertEq(actualTotalSupply, expectedTotalSupply);
    }

    function testOwnersBalanceShouldBeTotalSupply() external view {
        uint256 actualTotalSupply = manualToken.getTotalSupply();
        assertEq(manualToken.balanceOf(msg.sender), actualTotalSupply);
    }

    //////////////
    // Transfer///
    //////////////

    function testTheAmountShouldBeGreaterThanBalanceToTransfer() external {
        vm.expectRevert(ManualToken.ManualToken__InsufficeintBalance.selector);
        manualToken.transfer(bob, 1000000 ether);
    }

    function testTheOwnersBalanceDecreaseAfterTransfer() external {
        vm.prank(msg.sender);
        manualToken.transfer(bob, INITAL_SUPPLY);
        assertEq(manualToken.balanceOf(msg.sender), TOTAL_SUPPLY - INITAL_SUPPLY);
    }

    function testTheReceiversBalanceIncreaseAfterTransfer() external {
        vm.prank(msg.sender);
        manualToken.transfer(bob, INITAL_SUPPLY);
        assertEq(manualToken.balanceOf(bob), INITAL_SUPPLY);
    }

    function testTheTransferEventReturnsABoolWhenEverthingIsRight() external {
        vm.prank(msg.sender);
        bool success = manualToken.transfer(bob, INITAL_SUPPLY);
        assertEq(success, true);
    }

    function testTransferEventIsEmittedWhenTransferFunctionCalled() external {
        vm.prank(msg.sender);
        vm.expectEmit();

        emit Transfer(msg.sender, bob, INITAL_SUPPLY);

        manualToken.transfer(bob, INITAL_SUPPLY);
    }

    ////////////////
    // Approve /////
    ////////////////

    function testTheApproveFunctionRevertsWhenOwnerHasLessBalance() external {
        vm.expectRevert(ManualToken.ManualToken__InsufficeintBalance.selector);
        vm.prank(msg.sender);
        manualToken.approve(bob, 1000000 ether);
    }

    function testTheApprovedValueCannotBeZero() external {
        vm.expectRevert(ManualToken.ManualToken__ItShouldBeGreaterThanZero.selector);
        vm.prank(msg.sender);
        manualToken.approve(bob, 0 ether);
    }

    function testTheAllowedDataStructureWillBeUpdated() external {
        vm.prank(msg.sender);
        manualToken.approve(bob, INITAL_SUPPLY);

        assertEq(manualToken.allowance(msg.sender, bob), INITAL_SUPPLY);
    }

    function testTheApproveFunctionEmitsAnApproveEvent() external {
        vm.prank(msg.sender);
        vm.expectEmit();

        emit Approval(msg.sender, bob, INITAL_SUPPLY);

        manualToken.approve(bob, INITAL_SUPPLY);
    }

    function testTheApproveFunctionReturnsBoolWhenEverythingIsGood() external {
        vm.prank(msg.sender);
        (bool success) = manualToken.approve(bob, INITAL_SUPPLY);
        assertEq(success, true);
    }

    //////////////////////
    // Transfer From /////
    /////////////////////

    function testTheTransferFromRevertsWhenAmountIsGreaterThanAllowed() external {
        vm.prank(msg.sender);
        manualToken.approve(bob, INITAL_SUPPLY);

        vm.prank(bob);
        vm.expectRevert(ManualToken.ManualToken__InsufficeintBalance.selector);
        manualToken.transferFrom(msg.sender, alice, 100000 ether);
    }

    function testTheTransferFromFunctionRevertsIfTokenOwnerDoesntHaveSufficentBalance() external {
        vm.prank(msg.sender);
        manualToken.approve(bob, TOTAL_SUPPLY);

        vm.prank(bob);
        vm.expectRevert(ManualToken.ManualToken__InsufficeintBalance.selector);
        manualToken.transferFrom(msg.sender, alice, 100000 ether);
    }

    function testTheBalanceOfOwnerDecreasesWhenTransferFrom() external {
        address owner = manualToken.getOwner();
        console.log(manualToken.balanceOf(owner));

        vm.prank(owner);
        manualToken.approve(bob, INITAL_SUPPLY);

        assertEq(manualToken.allowance(owner, bob), INITAL_SUPPLY);

        vm.prank(bob);
        manualToken.transferFrom(owner, alice, INITAL_SUPPLY);
        uint256 remain = TOTAL_SUPPLY - INITAL_SUPPLY;

        assertEq(manualToken.balanceOf(msg.sender), remain);
    }

    function testTheBalanceOfTheReceiverIncreases() external {
        address owner = manualToken.getOwner();
        console.log(manualToken.balanceOf(owner));

        vm.prank(owner);
        manualToken.approve(bob, INITAL_SUPPLY);

        assertEq(manualToken.allowance(owner, bob), INITAL_SUPPLY);

        vm.prank(bob);
        manualToken.transferFrom(owner, alice, INITAL_SUPPLY);

        assertEq(manualToken.balanceOf(alice), INITAL_SUPPLY);
    }

    function testTheAllowedBalanceDecresesFromInitalAmount() external {
        address owner = manualToken.getOwner();
        console.log(manualToken.balanceOf(owner));

        vm.prank(owner);
        manualToken.approve(bob, INITAL_SUPPLY);

        assertEq(manualToken.allowance(owner, bob), INITAL_SUPPLY);

        vm.prank(bob);
        manualToken.transferFrom(owner, alice, INITAL_SUPPLY);

        assertEq(manualToken.allowance(owner, bob), 0);
    }

    function testTheTransferFromEmitsTransferEvent() external {
        address owner = manualToken.getOwner();
        console.log(manualToken.balanceOf(owner));

        vm.prank(owner);
        manualToken.approve(bob, INITAL_SUPPLY);

        assertEq(manualToken.allowance(owner, bob), INITAL_SUPPLY);

        vm.prank(bob);
        vm.expectEmit();

        emit Transfer(owner, alice, INITAL_SUPPLY);

        manualToken.transferFrom(owner, alice, INITAL_SUPPLY);
    }

    function testTheTransferFromFunctionReturnsABoolIfEverthingGood() external {
        address owner = manualToken.getOwner();
        console.log(manualToken.balanceOf(owner));

        vm.prank(owner);
        manualToken.approve(bob, INITAL_SUPPLY);

        assertEq(manualToken.allowance(owner, bob), INITAL_SUPPLY);

        vm.prank(bob);
        (bool success) = manualToken.transferFrom(owner, alice, INITAL_SUPPLY);

        assertEq(success, true);
    }
}
