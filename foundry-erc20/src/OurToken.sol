// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    // Kế thừa và khởi tạo tên "OurToken", ký hiệu "OT" [8]
    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        // Đúc (mint) toàn bộ lượng cung ban đầu cho người triển khai [8]
        _mint(msg.sender, initialSupply);
    }
}
