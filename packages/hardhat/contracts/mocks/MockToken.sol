// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    uint8 private _decimals;
    function decimals() public view override returns (uint8) {
        return _decimals;
    }
    constructor(string memory name, string memory symbol, uint8 decimals_, uint256 supply) ERC20(name, symbol) {
        _decimals = decimals_;
        _mint(msg.sender, supply);
    }
}