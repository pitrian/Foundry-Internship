// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title A sample Raffle Contract
 * @dev It implements Chainlink VRFv2.5 and Chainlink Automation
 */
contract Raffle {
    /* Errors */
    error Raffle__NotEnoughEthSent();

    /* State variables */
    uint256 private immutable i_entranceFee;
    // Mảng lưu trữ danh sách người chơi
    address payable[] private s_players; // [3]

    /* Events */
    // Khai báo sự kiện khi có người tham gia [4]
    event EnteredRaffle(address indexed player);

    /* Functions */
    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }

        // 1. Thêm người chơi vào mảng s_players [5]
        s_players.push(payable(msg.sender));

        // 2. Phát hành sự kiện để các dịch vụ off-chain hoặc front-end theo dõi [6]
        emit EnteredRaffle(msg.sender);
    }

    function pickWinner() public {}

    /** Getter Functions */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    // Hàm getter để lấy địa chỉ người chơi theo chỉ số (index)
    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }
}
