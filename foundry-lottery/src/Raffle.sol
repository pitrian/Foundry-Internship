// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Raffle {
    /* Errors */
    error Raffle__NotEnoughEthSent();

    /* State variables */
    uint256 private immutable i_entranceFee;
    // @dev Khoảng thời gian giữa các lần quay thưởng (giây)
    uint256 private immutable i_interval; // [3]
    address payable[] private s_players;
    uint256 private s_lastTimeStamp; // [4]

    /* Events */
    event EnteredRaffle(address indexed player);

    /* Functions */
    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp; // Khởi tạo mốc thời gian bắt đầu [4]
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }

    /**
     * @notice Hàm chọn người chiến thắng
     * @dev Kiểm tra xem đã đủ thời gian chờ (interval) chưa trước khi thực hiện
     */
    function pickWinner() external {
        // Kiểm tra điều kiện thời gian [5]
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert(); // Sẽ được thay bằng Custom Error ở bài sau
        }

        // Logic chọn người thắng sẽ dùng Chainlink VRF ở bài tiếp theo
    }

    /** Getter Functions */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
