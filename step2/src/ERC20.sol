// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "./interface/IERC20.sol";

contract ERC20 is IERC20 {
    string public name = "PoCoin";
    string public symbol = "POC";
    uint8 public decimals = 18;
    uint256 private _totalSupply;

    mapping(address account => uint256) private _balances;
    mapping(address account => mapping(address spender => uint256)) private _allowances;

    constructor(uint256 initialSupply) {
        _totalSupply = initialSupply * 10 ** uint256(decimals);
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
}
