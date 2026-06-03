// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() public {
        //us -> FundMeTest -> FundMe
        fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() public {
        console.log("Minimum USD:", fundMe.MINIMUM_USD());
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwnerIsMsgSender() public {
        console.log("Owner:", fundMe.i_owner());
        console.log("Test Contract Address:", address(this));
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
