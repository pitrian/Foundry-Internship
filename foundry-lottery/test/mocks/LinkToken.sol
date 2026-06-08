// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@solmate/tokens/ERC20.sol";

/**
 * @title LinkToken
 * @dev Hợp đồng giả lập token LINK để sử dụng trên mạng local (Anvil)
 */
contract LinkToken is ERC20 {
    constructor() ERC20("Link Token", "LINK", 18) {}

    /**
     * @dev Hàm mint để tạo thêm token cho việc kiểm thử
     */
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    /**
     * @dev Hỗ trợ chuẩn ERC-677 cho phép gửi token và thực thi hàm trong một giao dịch
     */
    function transferAndCall(
        address to,
        uint256 value,
        bytes calldata data
    ) external returns (bool success) {
        transfer(to, value);
        (success, ) = to.call(
            abi.encodeWithSignature(
                "onTokenTransfer(address,uint256,bytes)",
                msg.sender,
                value,
                data
            )
        );
        return success;
    }
}
