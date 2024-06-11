// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundeMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 10e18;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 489361;

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundeMe deployF = new DeployFundeMe();
        fundMe = deployF.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinUsd() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwner() public view {
        console.log("sender:", msg.sender);
        console.log("owner:", fundMe.getOwner());
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPrice() public view {
        uint256 ver = fundMe.getVersion();
        console.log("Ver:", fundMe.getVersion());
        console.log("address: ", address(fundMe));
        assertEq(ver, 4);
    }

    function testFundsNotEnougtEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFund() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAdressToAmoutFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAdrrFundToarrayFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerWidraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWidrawwithAsignedFounder() public funded {
        //Arrenge
        address owner = fundMe.getOwner();
        uint256 startingBalance = owner.balance;
        uint256 startingFundedBalance = address(fundMe).balance;

        //Act
        vm.prank(owner);
        fundMe.withdraw();

        //Assert
        uint256 finalOwnerBalance = owner.balance;
        uint256 finalFundMebalance = address(fundMe).balance;

        assertEq(finalFundMebalance, 0);
        assertEq(
            startingFundedBalance + startingBalance,
            finalOwnerBalance
        );
    }

    function testWidrMultiFounders() public funded{
        //Arrange
        address owner = fundMe.getOwner();
        uint160 numOfFounder = 10;
        uint160 startingIndex = 2;

        for(uint160 i = startingIndex; i <= numOfFounder; i++ ){
            hoax(address(i),SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingBalance = owner.balance;
        uint256 startingFundedBalance = address(fundMe).balance;
        
        //Act
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(owner);
        fundMe.withdraw();

        uint256 gasEnd = gasleft();
        uint256 gasUse = (gasStart-gasEnd) * tx.gasprice;
        console.log(gasUse);

        //Assert
        uint256 finalOwnerBalance = owner.balance;
        uint256 finalFundMebalance = address(fundMe).balance;

        assertEq(finalFundMebalance, 0);
        assertEq(
            startingFundedBalance + startingBalance,
            finalOwnerBalance
        );
    }


     function testWidrMultiFoundersCheaper() public funded{
        //Arrange
        address owner = fundMe.getOwner();
        uint160 numOfFounder = 10;
        uint160 startingIndex = 2;

        for(uint160 i = startingIndex; i <= numOfFounder; i++ ){
            hoax(address(i),SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingBalance = owner.balance;
        uint256 startingFundedBalance = address(fundMe).balance;
        
        //Act
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(owner);
        fundMe.cheaperWidraw();

        uint256 gasEnd = gasleft();
        uint256 gasUse = (gasStart-gasEnd) * tx.gasprice;
        console.log(gasUse);

        //Assert
        uint256 finalOwnerBalance = owner.balance;
        uint256 finalFundMebalance = address(fundMe).balance;

        assertEq(finalFundMebalance, 0);
        assertEq(
            startingFundedBalance + startingBalance,
            finalOwnerBalance
        );
    }
}

// unit
// specific part of code

//integration
// test how our code works wit other parts of our code

// forked
// test our code on simulated real envoirement

//staging
//test our code in a real envoirmenet
