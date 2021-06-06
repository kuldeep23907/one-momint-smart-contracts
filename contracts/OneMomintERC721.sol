// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OneMomintERC721 is Context,Pausable,Ownable,ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string baseURI;
    
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}
    
    function mint(
        string memory tokenURI
    ) external returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
    
    function setBaseURI(string memory baseURI_) external {
        baseURI = baseURI_;
    }
    
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

     /**
     * @dev Burns `tokenId`. See {ERC721-_burn}.
     *
     * Requirements:
     *
     * - The caller must own `tokenId` or be an approved operator.
     */
    function burn(uint256 tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(tokenId);
    }

     /**
     * @dev See {ERC721-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - the contract must not be paused.
     */
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        require(!paused(), "ERC721Pausable: token transfer while paused");
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