// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract OneMomintERC20 is Context,Pausable,Ownable,ERC20Capped {

    constructor(string memory _name, string memory _symbol, uint256 _cap) ERC20(_name,_symbol) ERC20Capped(_cap) {

    } 

     /**
     * @dev Mint `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function mint(address user, uint256 amount) external onlyOwner {
        _mint(user, amount);
    }

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:  /**
     * @dev Pause the contract functions
     */
    function burnFrom(address account, uint256 amount) public virtual {
        uint256 currentAllowance = allowance(account, _msgSender());
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        _approve(account, _msgSender(), currentAllowance - amount);
        _burn(account, amount);
    }

     /**
     * @dev See {ERC20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - the contract must not be paused.
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }

     /**
     * @dev Pause the contract functions
     */
    function pauseContract() external onlyOwner {
        _pause();
    }

    /**
     * @dev Unpause the contract functions
     */
    function unpauseContract() external onlyOwner {
        _unpause();
    }

}