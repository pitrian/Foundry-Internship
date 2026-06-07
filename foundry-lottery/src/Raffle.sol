// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import các thư viện cần thiết từ Chainlink [3, 5]
import {
    IVRFCoordinatorV2Plus
} from "chainlink/src/v0.8/vrf/dev/interfaces/IVRFCoordinatorV2Plus.sol";
import {
    VRFV2PlusClient
} from "chainlink/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import {
    VRFConsumerBaseV2Plus
} from "chainlink/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

/**
 * @title A sample Raffle Contract
 * @dev Hợp đồng kế thừa VRFConsumerBaseV2Plus để sử dụng số ngẫu nhiên [6, 7]
 */
contract Raffle is VRFConsumerBaseV2Plus {
    /* Errors */
    error Raffle__NotEnoughEthSent();

    /* State variables */
    // Biến cho logic Xổ số
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    // Biến cấu hình Chainlink VRF [8, 9]
    bytes32 private immutable i_gasLane;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    /* Events */
    event EnteredRaffle(address indexed player);

    /* Functions */
    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        // Khởi tạo hợp đồng cha [8, 10]
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }

    /**
     * @notice Hàm yêu cầu số ngẫu nhiên để chọn người thắng
     */
    function pickWinner() external {
        // Kiểm tra điều kiện thời gian (đã học bài trước)
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert();
        }

        // Thực hiện yêu cầu số ngẫu nhiên tới Chainlink VRF Coordinator [11, 12]
        // Trong VRF v2.5, yêu cầu được đóng gói vào một struct RandomWordsRequest
        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: i_gasLane,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false}) // Thanh toán phí bằng LINK
                )
            })
        );
    }

    /**
     * @dev Hàm callback mà Chainlink Node sẽ gọi lại để trả kết quả số ngẫu nhiên [13-15]
     */
    function fulfillRandomWords(
        uint256 /* requestId */,
        uint256[] calldata /* randomWords */
    ) internal override {
        // Logic chọn người thắng từ kết quả trả về sẽ được viết ở Bài 10 & 11
    }

    /** Getter Functions */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
