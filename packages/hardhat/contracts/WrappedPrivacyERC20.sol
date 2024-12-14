// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity ^0.8.24;

import "fhevm/lib/TFHE.sol";
import "fhevm/config/ZamaFHEVMConfig.sol";
import "fhevm/config/ZamaGatewayConfig.sol";
import "fhevm/gateway/GatewayCaller.sol";
import "fhevm-contracts/contracts/token/ERC20/extensions/ConfidentialERC20.sol";

/// @notice This contract implements an encrypted ERC20-like token with confidential balances using Zama's FHE library.
/// @dev It supports typical ERC20 functionality such as transferring tokens, minting, and setting allowances,
/// @dev but uses encrypted data types.
contract WrappedPrivacyERC20 is ConfidentialERC20 {

    /// @notice Constructor to initialize the token's name and symbol, and set up the owner
    /// @param name_ The name of the token
    /// @param symbol_ The symbol of the token
    constructor(address token) {
        super("My Confidential ERC20", "MCE20");
    }

}
