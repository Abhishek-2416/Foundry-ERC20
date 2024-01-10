// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {ManualToken} from "../src/ManualToken.sol";
import {DeployManualToken} from "../script/DeployManualToken.s.sol";

contract TestManualToken is Test {
    ManualToken public manualToken;
    DeployManualToken public deployer;

    //addresses
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant INITAL_SUPPLY = 1000 ether;

    function setUp() public {
        deployer = new DeployManualToken();
        manualToken = deployer.run();
    }

    function testName() external {
        string memory expectedName = "Manual Token";
        string memory actualName = manualToken.name();

        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testSymbol() external {
        string memory expectedSymbol = "MT";
        string memory actualSymbol = manualToken.symbol();

        assert(
            keccak256(abi.encodePacked(expectedSymbol)) ==
                keccak256(abi.encodePacked(actualSymbol))
        );
    }

    function testMint() external {
        vm.prank(msg.sender);
        manualToken.mint(bob, STARTING_BALANCE);
        manualToken.mint(alice, INITAL_SUPPLY);

        //Check the balance of bob
        assertEq(STARTING_BALANCE, manualToken.balanceOf(bob));

        //Check the balance of alice
        assertEq(INITAL_SUPPLY, manualToken.balanceOf(alice));
    }

    function testBurn() external {
        vm.prank(msg.sender);
        manualToken.mint(bob, INITAL_SUPPLY);

        //Checking bob balance before
        assertEq(manualToken.balanceOf(bob), INITAL_SUPPLY);

        //Burning the token
        vm.prank(msg.sender);
        manualToken.burn(bob, STARTING_BALANCE);

        //Checking bob balance after
        assertEq(
            manualToken.balanceOf(bob),
            (INITAL_SUPPLY - STARTING_BALANCE)
        );
    }

    function testApprove() external {
        vm.prank(msg.sender);
        manualToken.mint(bob, INITAL_SUPPLY);

        vm.prank(bob);
        manualToken.approve(alice, 1 ether);

        //Checking alice's allowance
        assertEq(manualToken.allowance(bob, alice), 1 ether);
    }

    function testTransfer() external {
        vm.prank(msg.sender);
        manualToken.mint(bob, INITAL_SUPPLY);

        vm.prank(bob);
        manualToken.transfer(alice, 1 ether);

        //Check alice's balance
        assertEq(1 ether, manualToken.balanceOf(alice));

        //Checking bob's balance
        assertEq(manualToken.balanceOf(bob), (INITAL_SUPPLY - 1 ether));
    }

    function testTransferFrom() external {
        vm.prank(msg.sender);
        manualToken.mint(bob, INITAL_SUPPLY);

        vm.prank(bob);
        manualToken.approve(alice, 1 ether);

        //Check allice's allowance
        assertEq(manualToken.allowance(bob, alice), 1 ether);

        //Check the transfer From
        address abhishek = makeAddr("abhishek");
        vm.prank(alice);
        manualToken.transferFrom(bob, abhishek, 1 ether);

        //Check abhishek balance
        assertEq(manualToken.balanceOf(abhishek), 1 ether);
    }

    //Test all Faliure Test

    //The address cannot be a null address
    function testWhenMintToZero() external {
        vm.expectRevert();
        vm.prank(msg.sender);
        manualToken.mint(address(0), INITAL_SUPPLY);
    }

    //The address to burn address cannot be zero
    function testWhenBurnToZero() external {
        vm.expectRevert();
        vm.prank(msg.sender);
        manualToken.burn(address(0), INITAL_SUPPLY);
    }

    //Address transfered cannot be zero
    function testTransferToZeroAddress() external {
        vm.prank(msg.sender);
        manualToken.mint(bob, INITAL_SUPPLY);

        vm.prank(bob);
        vm.expectRevert();
        manualToken.transfer(address(0), INITAL_SUPPLY);
    }

    //Address for TransferFrom cannot be zero
    function testTransferFromToZeroAddress() external {
        vm.prank(msg.sender);
        manualToken.mint(bob, INITAL_SUPPLY);

        vm.prank(bob);
        vm.expectRevert();
        manualToken.transferFrom(bob, address(0), STARTING_BALANCE);
    }

    //Fuzz Testing

    function testFuzzMint(address to, uint256 amount) external {
        vm.assume(to != address(0));
        manualToken.mint(to, amount);
        assertEq(manualToken.balanceOf(to), manualToken.totalSupply());
    }
}
