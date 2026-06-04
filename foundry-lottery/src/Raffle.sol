// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title A sample Raffle Contract
 * @author Patrick Collins
 * @notice This contract is for creating a sample raffle
 * @dev It implements Chainlink VRFv2.5 and Chainlink Automation
 */
contract Raffle {
    /* Errors */
    // Việc sử dụng tiền tố Raffle__ giúp dễ dàng xác định lỗi đến từ hợp đồng nào [5].
    error Raffle__NotEnoughEthSent();

    /* State variables */
    // Biến immutable được lưu trong bytecode, giúp truy xuất rẻ hơn biến storage [6, 7].
    uint256 private immutable i_entranceFee;

    /* Functions */
    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    /**
     * @notice Hàm tham gia xổ số
     * @dev Thay đổi từ public sang external để tiết kiệm gas vì không gọi nội bộ [1].
     */
    function enterRaffle() external payable {
        // Sử dụng mô hình if/revert với Custom Error thay vì require(string) để tối ưu gas [2, 5].
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
    }

    /**
     * @notice Hàm chọn người chiến thắng (Sẽ được triển khai logic ở các bài sau)
     */
    function pickWinner() public {}

    /** Getter Function */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
