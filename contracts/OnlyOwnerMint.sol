// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";

contract OnlyOwnerMint is ERC721 {
    
    /**
    * @dev
    * - このコントタクトをデプロイした人のアドレスの変数
    */
    address public owner;

    constructor() ERC721("OnlyOwnerMint", "OWNER") {
        owner = _msgSender();
    }

    /// @dev contractをデプロイしたアドレスだけがmint可能
    /// @dev mint先は、nftMintの実行者のアドレスに固定
    /// @dev つまり、contractオーナーのみmint可能で、オーナー自身のアドレスにmintされる
    function nftMint(uint256 tokenId) public {
        require(owner == _msgSender(), "Caller is not the owner.");
        _mint(_msgSender(), tokenId);
    }
}