// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "./IERC722Receiver.sol";

  /**
   * @dev Implementation of the {IERC722Receiver} interface.
   *
   * Accepts all token transfers. 
   * Make sure the contract is able to use its token with {IERC722-safeTransferFrom}, {IERC722-approve} or {IERC722-setApprovalForAll}.
   */
contract ERC722Holder is IERC722Receiver {

    /**
     * @dev See {IERC722Receiver-onERC722Received}.
     *
     * Always returns `IERC722Receiver.onERC722Received.selector`.
     */
    function onERC722Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC722Received.selector;
    }
}
