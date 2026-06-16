// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {
    IVRFCoordinatorV2Plus
} from "chainlink/src/v0.8/vrf/dev/interfaces/IVRFCoordinatorV2Plus.sol";
import {
    VRFV2PlusClient
} from "chainlink/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import {
    VRFConsumerBaseV2Plus
} from "chainlink/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {
    AutomationCompatibleInterface
} from "chainlink/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";

/**
 * @title A sample Raffle Contract
 * @dev Triển khai logic chọn người thắng sử dụng CEI (Checks-Effects-Interactions)
 */
contract Raffle is VRFConsumerBaseV2Plus, AutomationCompatibleInterface {
    /* Errors */
    error Raffle__NotEnoughEthSent();
    error Raffle__TransferFailed();
    error Raffle__RaffleNotOpen();
    error Raffle__UpkeepNotNeeded(
        uint256 balance,
        uint256 playersLength,
        uint256 raffleState
    );

    /* Type Declarations */
    enum RaffleState {
        OPEN,
        CALCULATING
    }

    /* State Variables */
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    RaffleState private s_raffleState; //bai12 enum
    address private s_recentWinner;

    // VRF Variables
    bytes32 private immutable i_gasLane;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    /* Events */
    event EnteredRaffle(address indexed player);
    event PickedWinner(address indexed winner);
    event RequestedRaffleWinner(uint256 indexed requestId);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        //bai12 khởi tạo trạng thái raffle là OPEN
        s_raffleState = RaffleState.OPEN;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) revert Raffle__NotEnoughEthSent();
        if (s_raffleState != RaffleState.OPEN) revert Raffle__RaffleNotOpen();

        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }

    /**
     * @dev Bài 19: Hàm kiểm tra điều kiện để quay thưởng (được gọi off-chain bởi Chainlink Nodes) [7]
     * upkeepNeeded trả về true khi thỏa mãn 4 điều kiện: thời gian, trạng thái, số dư và người chơi [8, 9].
     */
    function checkUpkeep(
        bytes memory /* checkData */
    )
        public
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */)
    {
        bool timeHasPassed = (block.timestamp - s_lastTimeStamp) >= i_interval;
        bool isOpen = RaffleState.OPEN == s_raffleState;
        bool hasBalance = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;

        upkeepNeeded = (timeHasPassed && isOpen && hasBalance && hasPlayers);
        return (upkeepNeeded, "0x0"); // Trả về "0x0" vì chúng ta không sử dụng dữ liệu performData [10]
    }
    /**
     * @dev Bài 19: Hàm thực hiện quay thưởng (thay thế hàm pickWinner cũ) [11]
     * Được gọi on-chain khi checkUpkeep trả về true [11].
     */
    function performUpkeep(bytes calldata /* performData */) external override {
        // Kiểm tra lại điều kiện một lần nữa để bảo mật [12]
        (bool upkeepNeeded, ) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded(
                address(this).balance,
                s_players.length,
                uint256(s_raffleState)
            );
        }

        s_raffleState = RaffleState.CALCULATING;

        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: i_gasLane,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
        emit RequestedRaffleWinner(requestId);
    }

    /**
     * @dev Oracle trả kết quả về đây. Sử dụng mô hình CEI để bảo mật [2].
     */
    function fulfillRandomWords(
        uint256 /* requestId */,
        uint256[] calldata randomWords
    ) internal override {
        //bai 16 mô hình CEI
        // 1. Checks (Hiện tại chưa cần thêm check logic phức tạp ở đây)

        // 2. Effects (Thay đổi trạng thái nội bộ trước [2])
        // Dùng Modulo để lấy chỉ số người thắng [3]
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        s_recentWinner = winner;

        s_raffleState = RaffleState.OPEN; // Mở lại raffle sau khi có kết quả
        s_players = new address payable[](0); // Reset mảng người chơi [4]
        s_lastTimeStamp = block.timestamp; // Cập nhật mốc thời gian [4]

        emit PickedWinner(winner); // Phát sự kiện người thắng [5]

        // 3. Interactions (Gửi ETH cuối cùng để tránh tấn công Reentrancy [2])
        (bool success, ) = winner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle__TransferFailed();
        }
    }

    /* Getters */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    function getRaffleState() external view returns (RaffleState) {
        return s_raffleState;
    }

    function getPlayer(uint256 index) external view returns (address) {
        return s_players[index];
    }

    function getRecentWinner() external view returns (address) {
        return s_recentWinner;
    }

    function getLastTimeStamp() external view returns (uint256) {
        return s_lastTimeStamp;
    }
}
