//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address user = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
        // Alternatively, you can deploy the contract directly here
        vm.deal(user, STARTING_BALANCE); // Give user some ether
    }

    function testIsMinimumUSDFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        console.log("Owner address:", msg.sender);
        console.log("FundMe owner address:", fundMe.i_owner());
        // Check if the owner of the FundMe contract is the same as the msg.sender
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedIsAccurate() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund(); // Should revert because no ETH is sent
    }

    function testFundedUpdatesDataStructure() public {
        vm.prank(user); //The next tx will be sent by user
        fundMe.fund{value: SEND_VALUE}(); // Send 0.1 ETH
        uint256 amountFunded = fundMe.getAddressToAmountFunded(user);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddFundersToFundersArray() public {
        vm.prank(user); // The next tx will be sent by user
        fundMe.fund{value: SEND_VALUE}(); // Send 0.1 ETH
        address funder = fundMe.getFunder(0); // Get the first funder
        assertEq(funder, user);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.prank(user); //The next tx will be sent by user
        fundMe.fund{value: SEND_VALUE}(); // User funds the contract

        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner()); // The next tx will be sent by the owner
        fundMe.withdraw();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
        assertEq(endingFundMeBalance, 0);
    }

    function testWithdrawFromMultipleFunders() public {
        uint256 numberOfFunders = 10;

        for (uint160 i = 1; i <= numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE); // Create a new address with SEND_VALUE
            fundMe.fund{value: SEND_VALUE}(); // Fund the contract
        }
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        uint256 startingGas = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner()); // The next tx will be sent by the owner
        fundMe.withdraw();
        uint256 gasUsed = (startingGas - gasleft());
        console.log("Gas used for withdrawal:", gasUsed);

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
        assertEq(endingFundMeBalance, 0);
    }
}
