// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Vault {
    struct Grant {
        address donor;
        address beneficiary;
        uint256 unlockTime;
        uint256 amount;
        bool claimed;
    }

    mapping(address => Grant) public grants;

    event GrantOffered(address indexed donor, address indexed beneficiary, uint256 amount, uint256 unlockTime);
    event GrantClaimed(address indexed beneficiary, uint256 amount);

    constructor() {}

    function offerGrant(address _beneficiary, uint256 _unlockTime) external payable {
        require(_beneficiary != address(0), "Beneficiary address cannot be zero");
        require(_unlockTime > block.timestamp, "Unlock time must be in the future");
        require(msg.value > 0, "Amount must be greater than zero");

        Grant memory newGrant = Grant({
            donor: msg.sender,
            beneficiary: _beneficiary,
            unlockTime: _unlockTime,
            amount: msg.value,
            claimed: false
        });

        grants[_beneficiary] = newGrant;

        emit GrantOffered(msg.sender, _beneficiary, msg.value, _unlockTime);
    }

    function claimGrant() external {
        Grant storage grant = grants[msg.sender];
        require(grant.beneficiary == msg.sender, "You are not the beneficiary of any grants");
        require(!grant.claimed, "Grant already claimed");
        require(block.timestamp >= grant.unlockTime, "Grant is not yet unlocked");

        grant.claimed = true;
        payable(msg.sender).transfer(grant.amount);

        emit GrantClaimed(msg.sender, grant.amount);
    }
}
