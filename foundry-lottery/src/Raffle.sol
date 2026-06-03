// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 *  @title A sample Raffle Contract
 *  @author Minh Chung
 *  @notice This contract is for creating a sample raffle
 *  @dev It implements Chainlink VRFv2.5 and Chainlink Automation
 */

contract Raffle {
    // Biến trạng thái (State variables)
    uint256 private immutable i_entranceFee;

    // Hàm khởi tạo (Constructor)
    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    // Hàm tham gia xổ số
    function enterRaffle() public payable {}

    // Hàm chọn người chiến thắng (Sẽ triển khai logic ở các bài sau)
    function pickWinner() public {}

    /** Getter Function */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
