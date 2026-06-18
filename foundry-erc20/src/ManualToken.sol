// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ManualToken {
    // Mapping để theo dõi số dư của từng địa chỉ [3]
    mapping(address => uint256) private s_balances;

    // Các hàm thông tin cơ bản [4]
    function name() public pure returns (string memory) {
        return "Manual Token";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether; // 100 + 18 số 0 [4]
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    // Trả về số dư của một chủ sở hữu [3]
    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    // Hàm chuyển tiền cơ bản [5]
    function transfer(address _to, uint256 _amount) public {
        uint256 previousBalance = balanceOf(msg.sender) + balanceOf(_to);
        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;
        require(balanceOf(msg.sender) + balanceOf(_to) == previousBalance);
    }
}
