// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity ^0.8.24;

import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import "fhevm-contracts/contracts/token/ERC20/ConfidentialERC20.sol";

/// @notice This contract implements an encrypted ERC20-like token with confidential balances using Zama's FHE library.
/// @dev It supports typical ERC20 functionality such as transferring tokens, minting, and setting allowances,
/// @dev but uses encrypted data types.
contract WrappedPrivacyERC20 is ConfidentialERC20 {
    address immutable public UNDERLYING;
    uint8 immutable public UNDERLYING_DECIMALS;

    constructor(address token) ConfidentialERC20("", "") {
        UNDERLYING = token;
        IERC20Metadata tokenContract = IERC20Metadata(token);
        _name = string.concat("Wrapped privacy - ", tokenContract.name());
        _symbol = string.concat("wp", tokenContract.symbol());
        UNDERLYING_DECIMALS = tokenContract.decimals();
    }

}
