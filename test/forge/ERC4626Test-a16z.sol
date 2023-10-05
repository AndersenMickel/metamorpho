// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import "erc4626-tests/ERC4626.test.sol";

import {BaseTest} from "./helpers/BaseTest.sol";

contract ERC4626StdTest is BaseTest, ERC4626Test {
    function setUp() public override(BaseTest, ERC4626Test) {
        super.setUp();

        _underlying_ = address(loanToken);
        _vault_ = address(vault);
        _delta_ = 0;
        _vaultMayBeEmpty = true;
        _unlimitedAmount = true;
    }
}
