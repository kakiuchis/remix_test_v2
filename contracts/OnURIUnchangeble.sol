// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Strings.sol";
import "@openzeppelin/contracts@4.6.0/utils/Base64.sol";

contract OnURIUnchangeble is ERC721URIStorage, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event TokenURIChanged(address indexed sender, uint256 indexed tokenID, string uri);

    constructor() ERC721("OnURIUnchangeble", "ONURI") {
}

    function nftMint() public onlyOwner {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        string memory imageData = '\
            <svg viewBox="0 0 350 350" fill="none" xmlns="http://www.w3.org/2000/svg">\
                <polygon points="50 175, 175 50, 300 175, 175 300" stroke="green" fill="yellow"/>\
            </svg>\
        ';

        bytes memory metaData = abi.encodePacked(
            '{"name": "',
            'MyOnchainNFT #',
            Strings.toString(newTokenId),
            '", "description": "My first on-Chain NFTs!!!",',
            '"image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(imageData)),
            '"}'         
        );

        string memory uri = string(abi.encodePacked("data:application/json;base64,", Base64.encode(metaData)));

        _mint(_msgSender(), newTokenId);

        _setTokenURI(newTokenId, uri);
        emit TokenURIChanged(_msgSender(), newTokenId, uri);
    }
}