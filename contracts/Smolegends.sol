// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "./FameToken.sol";
import "./Interfaces.sol";

contract Smolegends is ERC721EnumerableUpgradeable {
    uint256 public constant MAX_SUPPLY = 10_000;

    address public admin = msg.sender;

    mapping(address => bool) public updaters;
    mapping(uint256 => Smolegend) public smolegends;
    mapping(uint256 => Stake) public staked;

    ISmolegendsMetadata metadata;
    ISmolegendsReroller reroller;
    FameToken fameToken;

    bytes32 internal entropySauce;

    uint256 stakedCount;

    event Minted(uint256 id);
    event Staked(uint256 id);
    event Unstaked(uint256 id);
    event ClaimedFame(uint256 id);
    event Rerolled(uint256 id);
    event RerolledPart(uint256 id);
    event Update(uint256 id);

    struct Stake {
        address owner;
        uint256 timestamp;
    }

    modifier noCheaters() {
        uint256 size = 0;
        address acc = msg.sender;
        assembly {
            size := extcodesize(acc)
        }

        require(updaters[msg.sender] || (msg.sender == tx.origin && size == 0), "you're trying to cheat!");
        _;

        // We'll use the last caller hash to add entropy to next caller
        entropySauce = keccak256(abi.encodePacked(acc, block.coinbase));
    }

    function initialize(
        address meta,
        address roller,
        address fame
    ) external initializer {
        __ERC721_init("Smolegends", "SMOLEGEND");
        metadata = ISmolegendsMetadata(meta);
        reroller = ISmolegendsReroller(roller);
        fameToken = FameToken(fame);
    }

    function setUpdater(address updater, bool isUpdater) external {
        require(msg.sender == admin, "not admin");
        updaters[updater] = isUpdater;
    }

    function updateSmolegend(uint256 id, Smolegend memory smolegend) external {
        require(updaters[msg.sender], "not authorized to update");
        smolegends[id] = smolegend;
    }

    function mintAndStakeSmolegend() external {
        uint256 id = mintSmolegend();
        staked[id] = Stake({owner: msg.sender, timestamp: block.timestamp});
    }

    function mintSmolegend() public returns (uint256) {
        uint256 nextId = totalSupply() + 1;
        require(nextId <= MAX_SUPPLY, "max supply reached");

        _mint(msg.sender, nextId);
        rerollSmolegend(nextId);

        emit Minted(nextId);
        return nextId;
    }

    function rerollSmolegend(uint256 id) public noCheaters returns (Smolegend memory) {
        require(msg.sender == ownerOf(id) || msg.sender == staked[id].owner, "not your smolegend");
        return smolegends[id] = reroller.reroll(smolegends[id], id, entropySauce);
    }

    function rerollSmolegendPart(uint256 id, SmolegendPart part) public noCheaters returns (uint256) {
        require(msg.sender == ownerOf(id) || msg.sender == staked[id].owner, "not your smolegend");

        if (SmolegendPart.CLASS == part) {
            return smolegends[id].class = reroller.rerollPart(part, id, smolegends[id].class, entropySauce);
        }
        if (SmolegendPart.HEADGEAR == part) {
            return smolegends[id].headgear = reroller.rerollPart(part, id, smolegends[id].headgear, entropySauce);
        }
        if (SmolegendPart.ALIGNMENT == part) {
            return smolegends[id].alignment = reroller.rerollPart(part, id, smolegends[id].alignment, entropySauce);
        }
        if (SmolegendPart.OFFHAND == part) {
            return smolegends[id].offhand = reroller.rerollPart(part, id, smolegends[id].offhand, entropySauce);
        }
        if (SmolegendPart.BACK == part) {
            return smolegends[id].back = reroller.rerollPart(part, id, smolegends[id].back, entropySauce);
        }
        if (SmolegendPart.BODY == part) {
            return smolegends[id].body = reroller.rerollPart(part, id, smolegends[id].body, entropySauce);
        }
        if (SmolegendPart.RACE == part) {
            return smolegends[id].race = reroller.rerollPart(part, id, smolegends[id].race, entropySauce);
        }
        if (SmolegendPart.PET == part) {
            return smolegends[id].pet = reroller.rerollPart(part, id, smolegends[id].pet, entropySauce);
        }
        if (SmolegendPart.MAINHAND == part) {
            return smolegends[id].mainhand = reroller.rerollPart(part, id, smolegends[id].mainhand, entropySauce);
        }
        if (SmolegendPart.ITEM1 == part) {
            return smolegends[id].item1 = reroller.rerollPart(part, id, smolegends[id].item1, entropySauce);
        }
        if (SmolegendPart.FOOTGEAR == part) {
            return smolegends[id].footgear = reroller.rerollPart(part, id, smolegends[id].footgear, entropySauce);
        }
        return smolegends[id].item2 = reroller.rerollPart(part, id, smolegends[id].item2, entropySauce);
    }

    function stake(uint256 id) external {
        require(msg.sender == ownerOf(id), "not your smolegend");

        staked[id] = Stake({owner: msg.sender, timestamp: block.timestamp});
        stakedCount += 1;
    }

    function unstake(uint256 id) external {
        require(msg.sender == staked[id].owner, "not your staked smolegend");

        fameToken.mint(msg.sender, claimableFame(id));

        delete staked[id];
        stakedCount -= 1;
    }

    function claimFame(uint256 id) public {
        require(msg.sender == staked[id].owner, "not your staked smolegend");

        fameToken.mint(msg.sender, claimableFame(id));
        staked[id].timestamp = block.timestamp;
    }

    function claimableFame(uint256 id) public view returns (uint256) {
        uint256 timeDiff = block.timestamp > staked[id].timestamp ? block.timestamp - staked[id].timestamp : 0;
        return (timeDiff * reroller.getTotalPoints(smolegends[id])) / 1 days;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        Smolegend memory smolegend = smolegends[id];
        return metadata.getTokenURI(id, smolegend);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        require(staked[tokenId].timestamp == 0, "smolegend is staked");

        super._beforeTokenTransfer(from, to, tokenId);
    }
}
