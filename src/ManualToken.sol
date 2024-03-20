// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract ManualToken {
    //Errors
    error ManualToken__InsufficeintBalance();
    error ManualToken__ItShouldBeGreaterThanZero();

    //Events
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);

    string private s_name = "Manual Token";
    string private s_symbol = "MT";

    uint256 private constant DECIMALS = 18;
    uint256 private immutable i_totalSupply;
    address private owner;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    constructor(uint256 totalSupply) {
        i_totalSupply = totalSupply;
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    function balanceOf(address tokenOwner) external view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        if (amount > balances[msg.sender]) {
            revert ManualToken__InsufficeintBalance();
        }

        balances[to] += amount;
        balances[msg.sender] -= amount;
        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        if (_value > balances[msg.sender]) {
            revert ManualToken__InsufficeintBalance();
        }

        if (_value <= 0) {
            revert ManualToken__ItShouldBeGreaterThanZero();
        }

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        if (allowed[from][msg.sender] < amount) {
            revert ManualToken__InsufficeintBalance();
        }

        if (balances[from] <= amount) {
            revert ManualToken__InsufficeintBalance();
        }

        balances[from] -= amount;
        allowed[from][msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }

    //Getter Functions
    function getName() external view returns (string memory) {
        return s_name;
    }

    function getSymbol() external view returns (string memory) {
        return s_symbol;
    }

    function getDecimals() external pure returns (uint256) {
        return DECIMALS;
    }

    function getTotalSupply() external view returns (uint256) {
        return i_totalSupply;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function getAllowedAmount(address tokenOwner, address spender) external view returns (uint256) {
        return allowed[tokenOwner][spender];
    }
}
