// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EarnscapeContract5 is Ownable {
    IERC20 public earnsToken;
    address public contract4;
    address public earnscapeTreasury;
    uint256 public deploymentTime;
    uint256 public closingTime;

    event TokensTransferred(address indexed to, uint256 amount);

    modifier onlyContract4() {
        require(msg.sender == contract4, "Only Contract 4 can call this function");
        _;
    }

    constructor(IERC20 _earnsToken, address _earnscapeTreasury) Ownable(msg.sender) {
        earnsToken = _earnsToken;
        earnscapeTreasury = _earnscapeTreasury;
        deploymentTime = block.timestamp;
        closingTime = deploymentTime + 30 minutes;
    }

    function setContract4(address _contract4) external onlyOwner {
        contract4 = _contract4;
    }

    function transferTo(address to, uint256 amount) external onlyOwner {
        require(amount <= earnsToken.balanceOf(address(this)), "Insufficient balance");
        earnsToken.transfer(to, amount);
        emit TokensTransferred(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) external onlyOwner {
        require(amount <= earnsToken.allowance(from, address(this)), "Allowance exceeded");
        earnsToken.transferFrom(from, to, amount);
        emit TokensTransferred(to, amount);
    }

    function transferAll() external onlyOwner {
        uint256 balance = earnsToken.balanceOf(address(this));
        earnsToken.transfer(earnscapeTreasury, balance);
        emit TokensTransferred(earnscapeTreasury, balance);
    }

    function withdrawToContract4(uint256 amount) external onlyContract4 {
        require(amount <= earnsToken.balanceOf(address(this)), "Insufficient balance");
        earnsToken.transfer(contract4, amount);
        emit TokensTransferred(contract4, amount);
    }
}
