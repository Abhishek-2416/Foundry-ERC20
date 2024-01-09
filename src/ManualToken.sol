// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

contract ManualToken {
    mapping(address => uint256) s_balances;

    string public name = "Manual Token";

    function totalSupply() public view returns (uint256) {
        return 100 ether;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _amount) public {
        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;
    }
}
