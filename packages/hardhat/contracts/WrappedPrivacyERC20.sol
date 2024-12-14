// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity ^0.8.24;

import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {ConfidentialERC20} from "fhevm-contracts/contracts/token/ERC20/ConfidentialERC20.sol";

// import types from Zama's FHE library
import "fhevm/lib/TFHE.sol";

/// @notice This contract implements an encrypted ERC20-like token with confidential balances using Zama's FHE library.
/// @dev It supports typical ERC20 functionality such as transferring tokens, minting, and setting allowances,
/// @dev but uses encrypted data types.
contract WrappedPrivacyERC20 is ConfidentialERC20{
    using SafeERC20 for IERC20;
    using SafeCast for uint256;

    address immutable public UNDERLYING;
    uint8 immutable public UNDERLYING_DECIMALS;

    error ErrWeirdERC20FeeOnTransfer();

    constructor(address token) ConfidentialERC20("", "") {
        UNDERLYING = token;
        IERC20Metadata tokenContract = IERC20Metadata(token);
        _name = string.concat("Wrapped privacy - ", tokenContract.name());
        _symbol = string.concat("wp", tokenContract.symbol());
        UNDERLYING_DECIMALS = tokenContract.decimals();
    }

    function _normalizeAmount(uint256 amount) internal view returns (uint256 amountInPrivacyToken, uint256 amountInUnderlyingToken) {
        // current token has only `decimals() = 6 decimals`, so if token has more than 6 decimals, we need truncate it
        if (UNDERLYING_DECIMALS > decimals()) {
            amountInPrivacyToken = amount / (10 ** (UNDERLYING_DECIMALS - decimals()));
            amountInUnderlyingToken = amountInPrivacyToken * (10 ** (UNDERLYING_DECIMALS - decimals()));
        } else if (UNDERLYING_DECIMALS < decimals()) {
            amountInPrivacyToken = amount * 10 ** (decimals() - UNDERLYING_DECIMALS);
            amountInUnderlyingToken = amount;
        }
    }

    /**
     * @dev It does not incorporate any overflow check. It must be implemented
     *      by the function calling it.
     */
     function _unsafeBurnNoEvent(address account, uint64 amount) internal virtual {
        euint64 newBalanceAccount = TFHE.sub(_balances[account], amount);
        _balances[account] = newBalanceAccount;
        TFHE.allowThis(newBalanceAccount);
        TFHE.allow(newBalanceAccount, account);
    }

    // @notice Mints `amount` of tokens to the caller. No encryption is used since amount transferred is public.
    function mint(uint256 amount) external {
        (uint256 amountInPrivacyToken, uint256 amountInUnderlyingToken) = _normalizeAmount(amount);
        
        // @dev transfer underlying token to this contract, with a secure balance check
        uint256 previousBalance = IERC20(UNDERLYING).balanceOf(address(this));
        IERC20(UNDERLYING).safeTransferFrom(msg.sender, address(this), amountInUnderlyingToken);
        uint256 newBalance = IERC20(UNDERLYING).balanceOf(address(this));
        if (newBalance != previousBalance + amountInUnderlyingToken){
            revert ErrWeirdERC20FeeOnTransfer();
        }

        // @dev mint the same amount of privacy token to the caller
        _unsafeMint(msg.sender, amountInPrivacyToken.toUint64());
    }

    // @notice Burns `amount` of tokens from the caller.
    function burn(uint256 amount) external {
        (uint256 amountInPrivacyToken, uint256 amountInUnderlyingToken) = _normalizeAmount(amount);

        // @dev burn the same amount of privacy token from the caller
        _unsafeBurnNoEvent(msg.sender, amountInPrivacyToken.toUint64());

        // @dev transfer underlying token to the caller
        IERC20(UNDERLYING).safeTransfer(msg.sender, amountInUnderlyingToken);
    }

}
