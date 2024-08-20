// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum Mood { happy, sad }
    
    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("MoodNft", "MOOD") {
        s_tokenCounter = 0;
        string memory s_sadSvg = sadSvgImageUri;
        string memory s_happySvg = s_happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.happy;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        // if (!_isApprovedOrOwner(msg.sender, tokenId)) {
        //     revert MoodNft__CantFlipMoodIfNotOwner();
        // }

        if (s_tokenIdToMood[tokenId] == Mood.happy) {
            s_tokenIdToMood[tokenId] = Mood.sad;
        } else {
            s_tokenIdToMood[tokenId] = Mood.happy;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI = s_happySvgImageUri;
        if (s_tokenIdToMood[tokenId] == Mood.happy) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        return string(abi.encodePacked(_baseURI(),
            Base64.encode(bytes(abi.encodePacked(
                '{"name":"',
                name(), // You can add whatever name here
                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                imageURI,
                '"}'
            )))))
        ;
    }
}