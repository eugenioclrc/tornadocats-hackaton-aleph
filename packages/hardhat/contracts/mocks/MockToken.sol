// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor(string memory name, string memory symbol, uint8 decimals, uint256 supply) ERC20(name, symbol, decimals) {
        _mint(msg.sender, supply);
    }
}