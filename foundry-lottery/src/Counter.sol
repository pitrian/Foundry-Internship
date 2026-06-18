// SPDX-License-Identifier: MIT
// pragma solidity 0.8.19; dùng cái này để không bị lỗi khi deploy lên Sepolia, vì Sepolia chỉ hỗ trợ đến 0.8.35
pragma solidity 0.8.35;

contract Counter {
    uint256 public counter;

    constructor() {
        counter = 0;
    }

    function count() external {
        counter = counter + 1;
    }
}
