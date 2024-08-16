// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

contract ERC20Standard {
    // State variables
    address public owner;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events as per ERC20 standard
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Constructor to set the initial owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict function access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Internal function to transfer tokens
    function _transfer(address _from, address _to, uint256 _amount) internal returns (bool) {
        require(balanceOf[_from] >= _amount, "Insufficient balance");
        require(_to != address(0), "Invalid address");

        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }

    // Public function to transfer tokens
    function transfer(address _to, uint256 _amount) public returns (bool) {
        return _transfer(msg.sender, _to, _amount);
    }

    // Public function to transfer tokens from a specific address
    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
        require(allowance[_from][msg.sender] >= _amount, "Allowance exceeded");
        return _transfer(_from, _to, _amount);
    }

    // Public function to approve an address to spend tokens
    function approve(address _spender, uint256 _amount) public {
        allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
    }

    // Only the owner can mint new tokens
    function mint(address _receiver, uint256 _amount) public onlyOwner {
        require(_receiver != address(0), "Invalid address");

        balanceOf[_receiver] += _amount;
        totalSupply += _amount;
        emit Transfer(address(0), _receiver, _amount); // Emit Transfer event from zero address to new receiver
    }
}
