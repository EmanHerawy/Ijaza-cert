// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @title ERC722 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC722 asset contracts.
 */
interface IERC722Receiver {
    /**
     * @dev Whenever an {IERC722} `tokenId` token is transferred to this contract via {IERC722-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC722.onERC722Received.selector`.
     */
    function onERC722Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}
