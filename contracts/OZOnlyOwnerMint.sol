// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";

contract OZOnlyOwnerMint is ERC721, Ownable {
    
    /**
    * @dev
    * - このコントタクトをデプロイした人のアドレスの変数
    */
    // address public owner;

    constructor() ERC721("OZOnlyOwnerMint", "OZNER") {
        // owner = _msgSender();
    }

    /// @dev contractをデプロイしたアドレスだけに制御
    // modifier onlyOwner {
    //     require(owner == _msgSender(), "Caller is not the owner.");
    //     _;
    // }

    /// @dev contractをデプロイしたアドレスだけがmint可能（onlyOwner）
    /// @dev mint先は、nftMintの実行者のアドレスに固定
    /// @dev つまり、contractオーナーのみmint可能で、オーナー自身のアドレスにmintされる
    function nftMint(uint256 tokenId) public onlyOwner {
        _mint(_msgSender(), tokenId);
    }
}