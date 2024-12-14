// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {WrappedPrivacyERC20} from "./WrappedPrivacyERC20.sol";

contract TokenFactory {
    mapping(address token => address wrappedToken) public tokenMap;

    event TokenCreated(address indexed token, address indexed wrappedToken);

    function createToken(address token) external {
        require(tokenMap[token] == address(0), "Token already exists");

        WrappedPrivacyERC20 wtoken = new WrappedPrivacyERC20(token);
        tokenMap[token] = address(wtoken);

        emit TokenCreated(token, address(wtoken));
    }

}
