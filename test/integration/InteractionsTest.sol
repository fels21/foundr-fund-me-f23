// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundeMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe,WidrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 10e18;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 489361;

    function setUp() external{
        DeployFundeMe deployF = new DeployFundeMe();
        fundMe = deployF.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFUndInteraction() public{
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));


        WidrawFundMe widrawFundMe = new WidrawFundMe();
        widrawFundMe.widrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);

        //address funder = fundMe.getFunder(0);
        //assertEq(funder, USER);


    }

}