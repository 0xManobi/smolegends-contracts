// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./Interfaces.sol";

contract SmolegendsReroller is ISmolegendsReroller {
    // smolegendPart => traitId => count
    mapping(SmolegendPart => mapping(uint256 => uint256)) public traitIdTotal;

    function getTotalPoints(Smolegend memory smolegend) external view returns (uint256) {
        return
            getPartPoints(SmolegendPart.CLASS, smolegend.class) +
            getPartPoints(SmolegendPart.HEADGEAR, smolegend.headgear) +
            getPartPoints(SmolegendPart.ALIGNMENT, smolegend.alignment) +
            getPartPoints(SmolegendPart.OFFHAND, smolegend.offhand) +
            getPartPoints(SmolegendPart.BACK, smolegend.back) +
            getPartPoints(SmolegendPart.BODY, smolegend.body) +
            getPartPoints(SmolegendPart.RACE, smolegend.race) +
            getPartPoints(SmolegendPart.PET, smolegend.pet) +
            getPartPoints(SmolegendPart.MAINHAND, smolegend.mainhand) +
            getPartPoints(SmolegendPart.ITEM1, smolegend.item1) +
            getPartPoints(SmolegendPart.FOOTGEAR, smolegend.footgear) +
            getPartPoints(SmolegendPart.ITEM2, smolegend.item2);
    }

    function getPartPoints(SmolegendPart part, uint256 traitId) public view returns (uint256) {
        uint256 pct = (traitIdTotal[part][traitId] * 1 ether) / 10_000;

        if (pct < 1 ether) return 2 ether;
        if (pct >= 1 ether && pct < 3 ether) return 1.5 ether;
        if (pct >= 3 ether && pct < 5 ether) return 1 ether;
        if (pct >= 5 ether && pct < 10 ether) return .75 ether;
        if (pct >= 10 ether && pct < 15 ether) return .5 ether;
        if (pct >= 15 ether && pct < 30 ether) return .25 ether;
        if (pct >= 30 ether && pct < 60 ether) return .125 ether;
        return .0625 ether;
    }

    function reroll(
        Smolegend memory smolegend,
        uint256 smolegendId,
        bytes32 extraRandomness
    ) external returns (Smolegend memory) {
        uint256 rand = _rand(extraRandomness);
        smolegend.class = _rerollPart(SmolegendPart.CLASS, smolegendId, smolegend.class, rand);
        smolegend.headgear = _rerollPart(SmolegendPart.HEADGEAR, smolegendId, smolegend.headgear, rand);
        smolegend.alignment = _rerollPart(SmolegendPart.ALIGNMENT, smolegendId, smolegend.alignment, rand);
        smolegend.offhand = _rerollPart(SmolegendPart.OFFHAND, smolegendId, smolegend.offhand, rand);
        smolegend.back = _rerollPart(SmolegendPart.BACK, smolegendId, smolegend.back, rand);
        smolegend.body = _rerollPart(SmolegendPart.BODY, smolegendId, smolegend.body, rand);
        smolegend.race = _rerollPart(SmolegendPart.RACE, smolegendId, smolegend.race, rand);
        smolegend.pet = _rerollPart(SmolegendPart.PET, smolegendId, smolegend.pet, rand);
        smolegend.mainhand = _rerollPart(SmolegendPart.MAINHAND, smolegendId, smolegend.mainhand, rand);
        smolegend.item1 = _rerollPart(SmolegendPart.ITEM1, smolegendId, smolegend.item1, rand);
        smolegend.footgear = _rerollPart(SmolegendPart.FOOTGEAR, smolegendId, smolegend.footgear, rand);
        smolegend.item2 = _rerollPart(SmolegendPart.ITEM2, smolegendId, smolegend.item2, rand);
        return smolegend;
    }

    function rerollPart(
        SmolegendPart part,
        uint256 smolegendId,
        uint256 oldTraitId,
        bytes32 extraRandomness
    ) external returns (uint256) {
        uint256 rand = _rand(extraRandomness);
        return _rerollPart(part, smolegendId, oldTraitId, rand);
    }

    function _rerollPart(
        SmolegendPart part,
        uint256 smolegendId,
        uint256 oldTraitId,
        uint256 rand
    ) internal returns (uint256) {
        if (SmolegendPart.CLASS == part) {
            return _updateTraitId(rand, "CLASS", smolegendId, SmolegendPart.CLASS, oldTraitId, 3);
        }
        if (SmolegendPart.HEADGEAR == part) {
            return _updateTraitId(rand, "HEADGEAR", smolegendId, SmolegendPart.HEADGEAR, oldTraitId, 3);
        }
        if (SmolegendPart.ALIGNMENT == part) {
            return _updateTraitId(rand, "ALIGNMENT", smolegendId, SmolegendPart.ALIGNMENT, oldTraitId, 3);
        }
        if (SmolegendPart.OFFHAND == part) {
            return _updateTraitId(rand, "OFFHAND", smolegendId, SmolegendPart.OFFHAND, oldTraitId, 3);
        }
        if (SmolegendPart.BACK == part) {
            return _updateTraitId(rand, "BACK", smolegendId, SmolegendPart.BACK, oldTraitId, 3);
        }
        if (SmolegendPart.BODY == part) {
            return _updateTraitId(rand, "BODY", smolegendId, SmolegendPart.BODY, oldTraitId, 3);
        }
        if (SmolegendPart.RACE == part) {
            return _updateTraitId(rand, "RACE", smolegendId, SmolegendPart.RACE, oldTraitId, 3);
        }
        if (SmolegendPart.PET == part) {
            return _updateTraitId(rand, "PET", smolegendId, SmolegendPart.PET, oldTraitId, 3);
        }
        if (SmolegendPart.MAINHAND == part) {
            return _updateTraitId(rand, "MAINHAND", smolegendId, SmolegendPart.MAINHAND, oldTraitId, 3);
        }
        if (SmolegendPart.ITEM1 == part) {
            return _updateTraitId(rand, "ITEM1", smolegendId, SmolegendPart.ITEM1, oldTraitId, 3);
        }
        if (SmolegendPart.FOOTGEAR == part) {
            return _updateTraitId(rand, "FOOTGEAR", smolegendId, SmolegendPart.FOOTGEAR, oldTraitId, 3);
        }

        return _updateTraitId(rand, "ITEM2", smolegendId, SmolegendPart.ITEM2, oldTraitId, 3);
    }

    function _updateTraitId(
        uint256 rand,
        string memory val,
        uint256 spicy,
        SmolegendPart part,
        uint256 oldTraitId,
        uint256 maxTraitId
    ) internal returns (uint256 newTraitId) {
        if (traitIdTotal[part][oldTraitId] > 0) {
            traitIdTotal[part][oldTraitId] -= 1;
        }

        newTraitId = (_randomize(rand, val, spicy) % maxTraitId) + 1;
        traitIdTotal[part][newTraitId] += 1;
    }

    /// @dev Create a bit more of randomness
    function _randomize(
        uint256 rand,
        string memory val,
        uint256 spicy
    ) internal pure returns (uint256) {
        return uint256(keccak256(abi.encode(rand, val, spicy)));
    }

    function _rand(bytes32 entropySauce) internal view returns (uint256) {
        return
            uint256(
                keccak256(abi.encodePacked(msg.sender, block.timestamp, block.basefee, block.timestamp, entropySauce))
            );
    }
}
