// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./Interfaces.sol";

contract SmolegendsMetadata is ISmolegendsMetadata {
    address public manager;

    mapping(uint256 => address) public classes;
    mapping(uint256 => address) public headgears;
    mapping(uint256 => address) public alignments;
    mapping(uint256 => address) public offhands;
    mapping(uint256 => address) public backs;
    mapping(uint256 => address) public bodies;
    mapping(uint256 => address) public races;
    mapping(uint256 => address) public pets;
    mapping(uint256 => address) public mainhands;
    mapping(uint256 => address) public items1;
    mapping(uint256 => address) public footgears;
    mapping(uint256 => address) public items2;

    string public constant header =
    '<svg id="smolegend" width="100%" height="100%" version="1.1" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">';
    string public constant footer =
    "<style>#smolegend{shape-rendering: crispedges; image-rendering: -webkit-crisp-edges; image-rendering: -moz-crisp-edges; image-rendering: crisp-edges; image-rendering: pixelated; -ms-interpolation-mode: nearest-neighbor;}</style></svg>";

    string public constant divider =
    "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAAK5JREFUeJzt2sEJwDAMwMC0++/cDuHCJVT6G4R+Nl5rxjOc/4KRw/2VxakUQAtoCqAFNAXQApoCaAFNAbSApgBaQPP7ANfaY6U9lh3idQ+YUAAtoCmAFtAUQAtoCqAFNAXQApoCaAFNAbSApgBaQFMALaApgBbQFEALaAqgBTQF0AKaAmgBTQG0gKYHiSE7xOtBYkIBtICmAFpAUwAtoCmAFtAUQAtoCqAFNL8P8AJRewhxV6TqJgAAAABJRU5ErkJggg==";

    function getSVG(Smolegend memory smolegend) public view returns (string memory) {
        return string(abi.encodePacked(header, wrapTag(divider, false), getSVGTraits(smolegend), footer));
    }

    function getTokenURI(uint256 id, Smolegend memory smolegend) external view returns (string memory) {
        return _buildSmolegendURI(_getUpper(id), getSVG(smolegend), getAttributes(smolegend));
    }

    function _buildSmolegendURI(
        bytes memory upper,
        string memory svg,
        string memory attributes
    ) internal pure returns (string memory) {
        return
        string(
            abi.encodePacked(
                "data:application/json;base64,",
                BBase64.encode(bytes(abi.encodePacked(upper, BBase64.encode(bytes(svg)), '",', attributes, "}")))
            )
        );
    }

    function _getUpper(uint256 id_) internal pure returns (bytes memory) {
        return
        abi.encodePacked(
            '{"name":"Smolegend #',
            toString(id_),
            '", "description":"lol k", "image": "',
            "data:image/svg+xml;base64,"
        );
    }

    function setClasses(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            classes[ids[index]] = source;
        }
    }

    function setHeadgears(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            headgears[ids[index]] = source;
        }
    }

    function setAlignments(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            alignments[ids[index]] = source;
        }
    }

    function setOffhands(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            offhands[ids[index]] = source;
        }
    }

    function setBacks(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            backs[ids[index]] = source;
        }
    }

    function setBodies(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            bodies[ids[index]] = source;
        }
    }

    function setRaces(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            races[ids[index]] = source;
        }
    }

    function setPets(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            pets[ids[index]] = source;
        }
    }

    function setMainhands(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            mainhands[ids[index]] = source;
        }
    }

    function setItems1(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            items1[ids[index]] = source;
        }
    }

    function setFootgears(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            footgears[ids[index]] = source;
        }
    }

    function setItems2(uint256[] calldata ids, address source) external {
        // require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < ids.length; index++) {
            items2[ids[index]] = source;
        }
    }

    function getSVGTraits(Smolegend memory smolegend) internal view returns (string memory) {
        return
        string(
            abi.encodePacked(
                get(SmolegendPart.CLASS, smolegend.class),
                get(SmolegendPart.HEADGEAR, smolegend.headgear),
                get(SmolegendPart.ALIGNMENT, smolegend.alignment),
                get(SmolegendPart.OFFHAND, smolegend.offhand),
                get(SmolegendPart.BACK, smolegend.back),
                get(SmolegendPart.BODY, smolegend.body),
                get(SmolegendPart.RACE, smolegend.race),
                get(SmolegendPart.PET, smolegend.pet),
                get(SmolegendPart.MAINHAND, smolegend.mainhand),
                get(SmolegendPart.ITEM1, smolegend.item1),
                get(SmolegendPart.FOOTGEAR, smolegend.footgear),
                get(SmolegendPart.ITEM2, smolegend.item2)
            )
        );
    }

    function call(address source, bytes memory sig) internal view returns (string memory svg) {
        (bool succ, bytes memory ret) = source.staticcall(sig);
        require(succ, "failed to get data");
        svg = abi.decode(ret, (string));
    }

    function get(SmolegendPart part, uint256 id) internal view returns (string memory data_) {
        address source = part == SmolegendPart.CLASS ? classes[id] : part == SmolegendPart.HEADGEAR
        ? headgears[id]
        : part == SmolegendPart.ALIGNMENT
        ? alignments[id]
        : part == SmolegendPart.OFFHAND
        ? offhands[id]
        : part == SmolegendPart.BACK
        ? backs[id]
        : part == SmolegendPart.BODY
        ? bodies[id]
        : part == SmolegendPart.RACE
        ? races[id]
        : part == SmolegendPart.PET
        ? pets[id]
        : part == SmolegendPart.MAINHAND
        ? mainhands[id]
        : part == SmolegendPart.ITEM1
        ? items1[id]
        : part == SmolegendPart.FOOTGEAR
        ? footgears[id]
        : items2[id];

        data_ = wrapTag(call(source, getData(part, id)), part == SmolegendPart.OFFHAND || part == SmolegendPart.ITEM2);
    }

    function wrapTag(string memory uri, bool moveToLeft) internal pure returns (string memory) {
        if (bytes(uri).length == 0) {
            return "";
        }
        return
        string(
            abi.encodePacked(
                "<image",
                moveToLeft ? ' transform="translate(-49, 0)"' : "",
                ' x="0" y="0" width="64" height="64" image-rendering="pixelated" preserveAspectRatio="xMidYMid" xlink:href="data:image/png;base64,',
                uri,
                '"/>'
            )
        );
    }

    function getData(SmolegendPart part, uint256 id) internal pure returns (bytes memory data) {
        string memory s = string(
            abi.encodePacked(
                part == SmolegendPart.CLASS ? "class" : part == SmolegendPart.HEADGEAR
            ? "headgear"
            : part == SmolegendPart.ALIGNMENT
            ? "alignment"
            : part == SmolegendPart.BACK
            ? "back"
            : part == SmolegendPart.BODY
            ? "body"
            : part == SmolegendPart.RACE
            ? "race"
            : part == SmolegendPart.PET
            ? "pet"
            : part == SmolegendPart.MAINHAND || part == SmolegendPart.OFFHAND
            ? "weapon"
            : part == SmolegendPart.ITEM1 || part == SmolegendPart.ITEM2
            ? "item"
            : "footgear",
                toString(id),
                "()"
            )
        );

        return abi.encodeWithSignature(s, "");
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function getAttributes(Smolegend memory smolegend) internal pure returns (string memory) {
        return
        string(
            abi.encodePacked(
                '"attributes": [',
                '{"trait_type":"Class","value":"',
                getClassName(smolegend.class),
                '"},',
                '{"trait_type":"Headgear","value":"',
                getHeadgearName(smolegend.headgear),
                '"},',
                '{"trait_type":"Alignment","value":"',
                getAlignmentName(smolegend.alignment),
                '"},',
                '{"trait_type":"Offhand","value":"',
                getOffhandName(smolegend.offhand),
                '"},',
                '{"trait_type":"Back","value":"',
                getBackName(smolegend.back),
                '"},',
                '{"trait_type":"Body","value":"',
                getBodyName(smolegend.body),
                '"},',
                '{"trait_type":"Race","value":"',
                getRaceName(smolegend.race),
                '"},',
                '{"trait_type":"Pet","value":"',
                getPetName(smolegend.pet),
                '"},',
                '{"trait_type":"Mainhand","value":"',
                getMainhandName(smolegend.mainhand),
                '"},',
                '{"trait_type":"Item1","value":"',
                getItem1Name(smolegend.item1),
                '"},',
                '{"trait_type":"Footgear","value":"',
                getFootgearName(smolegend.footgear),
                '"},',
                '{"trait_type":"Item2","value":"',
                getItem2Name(smolegend.item2),
                '"}',
                "]"
            )
        );
    }

    function getClassName(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }

    function getHeadgearName(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }

    function getAlignmentName(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }

    function getOffhandName(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }

    function getBackName(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }

    function getBodyName(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }

    function getRaceName(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }

    function getPetName(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }

    function getMainhandName(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }

    function getItem1Name(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }

    function getFootgearName(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }

    function getItem2Name(uint256 id) public pure returns (string memory) {
        if (id == 0) return "None";
        if (id == 1) return "Leather Bracers +2";
        if (id == 2) return "Leather Vambraces +2";
    }
}

/// @title BBase64
/// @author Brecht Devos - <brecht@loopring.org>
/// @notice Provides a function for encoding some bytes in BBase64
/// @notice NOT BUILT BY ETHERORCS TEAM. Thanks Bretch Devos!
library BBase64 {
    string internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return "";

        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
        // set the actual output length
            mstore(result, encodedLen)

        // prepare the lookup table
            let tablePtr := add(table, 1)

        // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

        // result ptr, jump over length
            let resultPtr := add(result, 32)

        // run over the input, 3 bytes at a time
            for {

            } lt(dataPtr, endPtr) {

            } {
                dataPtr := add(dataPtr, 3)

            // read 3 bytes
                let input := mload(dataPtr)

            // write 4 characters
                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
                resultPtr := add(resultPtr, 1)
                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
                resultPtr := add(resultPtr, 1)
                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F)))))
                resultPtr := add(resultPtr, 1)
                mstore(resultPtr, shl(248, mload(add(tablePtr, and(input, 0x3F)))))
                resultPtr := add(resultPtr, 1)
            }

        // padding with '='
            switch mod(mload(data), 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }
        }

        return result;
    }
}
