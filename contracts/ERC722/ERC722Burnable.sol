// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "./ERC722.sol";

/**
 * @title ERC722 Burnable Token
 * @dev ERC722 Token that can be irreversibly burned (destroyed).
 */
abstract contract ERC722Burnable is Context, ERC722 {
    /**
     * @dev Burns `tokenId`. See {ERC722-_burn}.
     *
     * Requirements:
     *
     * - The caller must own `tokenId` or be an approved operator.
     */
    function burn(uint256 tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(_isOwner(_msgSender(), tokenId), "ERC722Burnable: caller is not owner nor approved");
        _burn(tokenId);
    }
}
