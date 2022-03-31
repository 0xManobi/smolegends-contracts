// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FameToken is ERC20 {
    address public admin;
    mapping(address => bool) public minters;

    constructor() ERC20("Fame Token", "FAME") {
        admin = msg.sender;
        minters[admin] = true;
    }

    function setMinter(address minter, bool isMinter) external {
        require(msg.sender == admin, "not authorized");
        minters[minter] = isMinter;
    }

    function setAdmin(address newAdmin) external {
        require(msg.sender == admin || admin == address(0), "not authorized");
        admin = newAdmin;
    }

    function mint(address to, uint256 amount) external {
        require(minters[msg.sender], "not authorized to mint");
        _mint(to, amount);
    }
}
