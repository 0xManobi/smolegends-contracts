// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

struct Smolegend {
    uint256 class;
    uint256 headgear;
    uint256 alignment;
    uint256 offhand;
    uint256 back;
    uint256 body;
    uint256 race;
    uint256 pet;
    uint256 mainhand;
    uint256 item1;
    uint256 footgear;
    uint256 item2;
}

enum SmolegendPart {
    CLASS, // 0
    HEADGEAR, // 1
    ALIGNMENT, // 2
    OFFHAND, // 3
    BACK, // 4
    BODY, // 5
    RACE, // 6
    PET, // 7
    MAINHAND, // 8
    ITEM1, // 9
    FOOTGEAR, // 10
    ITEM2 // 11
}

interface ISmolegendsMetadata {
    function getTokenURI(uint256 smolegendId, Smolegend memory smolegend) external view returns (string memory);
}

interface ISmolegendsReroller {
    function getTotalPoints(Smolegend memory smolegend) external view returns (uint256);

    function getPartPoints(SmolegendPart part, uint256 traitId) external view returns (uint256);

    function reroll(
        Smolegend memory smolegend,
        uint256 smolegendId,
        bytes32 extraRandomness
    ) external returns (Smolegend memory);

    function rerollPart(
        SmolegendPart part,
        uint256 smolegendId,
        uint256 oldTraitId,
        bytes32 extraRandomness
    ) external returns (uint256);
}
