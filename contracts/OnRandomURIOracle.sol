// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Strings.sol";
import "@openzeppelin/contracts@4.6.0/utils/Base64.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract OnRandomURIOracle is ERC721URIStorage, VRFConsumerBaseV2 {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Color {
        string name;
        string code;
    }

    Color[] public colors;

    /// https://docs.chain.link/vrf/v2/subscription/examples/get-a-random-number
    VRFCoordinatorV2Interface COORDINATOR;
    uint64 s_subscriptionId;
    address vrfCoordinator = 0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed;
    bytes32 keyHash = 0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f;
    uint32 callbackGasLimit = 200000;
    uint16 requestConfirmations = 3;
    uint32 numWords =  4;
    uint256[] public s_randomWords;
    uint256 public s_requestId;
    address s_owner;

    event TokenURIChanged(address indexed sender, uint256 indexed tokenID, string uri);

    constructor(uint64 subscriptionId) ERC721("OnRandomURIOracle", "ONO") VRFConsumerBaseV2(vrfCoordinator){
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;

        colors.push(Color("Yellow", "ffff00"));
        colors.push(Color("Whitesmoke","#f5f5f5"));
        colors.push(Color("Blue","#0000ff"));
        colors.push(Color("Pink","#ffc0cb"));
        colors.push(Color("Green","#008000"));
        colors.push(Color("Gold","#FFD700"));
        colors.push(Color("Purple","#800080"));
        colors.push(Color("Light Green","#90EE90"));
        colors.push(Color("Orange","#FFA500"));
        colors.push(Color("Gray","#808080"));  
    }

    function nftMint() public onlyOwner {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        uint256 colorNum1 = s_randomWords[0] % colors.length;
        uint256 colorNum2 = s_randomWords[1] % colors.length;
        uint256 colorNum3 = s_randomWords[2] % colors.length;
        uint256 colorNum4 = s_randomWords[3] % colors.length;

        string memory colorName1 = colors[colorNum1].name;
        string memory colorName2 = colors[colorNum2].name;
        string memory colorName3 = colors[colorNum3].name;
        string memory colorName4 = colors[colorNum4].name;

        string memory imageData = _getImage(colorNum1, colorNum2, colorNum3, colorNum4);


        bytes memory metaData = abi.encodePacked(
            '{"name": "',
            'color squares #',
            Strings.toString(newTokenId),
            '", "description": "combined squares",',
            '"image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(imageData)),
            '", "attributes": [{ "treat_type": "1st color", "value": "',
            colorName1,
            '"}, { "treat_type": "2nd color", "value": "',
            colorName2,
            '"}, { "treat_type": "3rd color", "value": "',
            colorName3,
            '"}, { "treat_type": "4th color", "value": "',
            colorName4,
            '"}]}'         
        );

        string memory uri = string(abi.encodePacked("data:application/json;base64,", Base64.encode(metaData)));

        _mint(_msgSender(), newTokenId);

        _setTokenURI(newTokenId, uri);
        emit TokenURIChanged(_msgSender(), newTokenId, uri);
    }

    function _getImage(uint256 colorNum1, uint256 colorNum2, uint256 colorNum3, uint256 colorNum4) internal view returns (string memory) {
        string memory colorCode1 = colors[colorNum1].code;
        string memory colorCode2 = colors[colorNum2].code;
        string memory colorCode3 = colors[colorNum3].code;
        string memory colorCode4 = colors[colorNum4].code;

        return(
            string(
                abi.encodePacked(
                    '<svg viewBox="0 0 350 350" xmlns="http://www.w3.org/2000/svg">',
                    '<polygon points="0 0, 175 0, 175 175, 0 175" stroke="black" fill="',
                    colorCode1,
                    '" />',
                    '<polygon points="175 0, 350 0, 350 175, 175 175" stroke="black" fill="',
                    colorCode2,
                    '" />',
                    '<polygon points="0 175, 175 175, 175 350, 0 350" stroke="black" fill="',
                    colorCode3,
                    '" />',
                    '<polygon points="175 175, 350 175, 350 350, 175 350" stroke="black" fill="',
                    colorCode4,
                    '" />',
                    '</svg>'
                )
            )
        );
    }

    function requestRandomWords() external onlyOwner {
        s_requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
        ) internal override {
            s_randomWords = randomWords;
            }

    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }
}