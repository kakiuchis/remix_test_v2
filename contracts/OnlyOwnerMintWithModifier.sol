// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";

contract OnlyOwnerMintWithModifier is ERC721 {
    
    /**
    * @dev
    * - このコントタクトをデプロイした人のアドレスの変数
    */
    address public owner;

    constructor() ERC721("OnlyOwnerMintWithModifier", "OWNERMOD") {
        owner = _msgSender();
    }

    /// @dev contractをデプロイしたアドレスだけに制御
    modifier onlyOwner {
        require(owner == _msgSender(), "Caller is not the owner.");
        _;
    }

    /// @dev contractをデプロイしたアドレスだけがmint可能（onlyOwner）
    /// @dev mint先は、nftMintの実行者のアドレスに固定
    /// @dev つまり、contractオーナーのみmint可能で、オーナー自身のアドレスにmintされる
    function nftMint(uint256 tokenId) public onlyOwner {
        _mint(_msgSender(), tokenId);
    }
}