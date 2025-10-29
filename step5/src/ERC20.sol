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

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function _transfer(address from, address to, uint256 value) private {
        if (from == address(0)) {
            revert("Invalid sender");
        }
        if (to == address(0)) {
            revert("Invalid receiver");
        }
        if (_balances[from] < value) {
            revert("Insufficient balance");
        }

        _balances[from] -= value;
        _balances[to] += value;
        emit Transfer(from, to, value);
    }

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) public override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) public override returns (bool) {
        if (spender == address(0)) {
            revert("Invalid spender");
        }

        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        if (_allowances[from][msg.sender] < value) {
            revert("Insufficient allowance");
        }

        _allowances[from][msg.sender] -= value;
        _transfer(from, to, value);
        return true;
    }
}
