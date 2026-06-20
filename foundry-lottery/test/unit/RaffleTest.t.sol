// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {Test, console} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract RaffleTest is Test {
    /* Biến trạng thái */
    Raffle public raffle;
    HelperConfig public helperConfig;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint256 subscriptionId;
    uint32 callbackGasLimit;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    function setUp() external {
        // Triển khai hợp đồng thông qua script DeployRaffle
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.run();

        // Cấp số dư ban đầu cho người chơi giả lập
        vm.deal(PLAYER, STARTING_USER_BALANCE);

        // Trích xuất cấu hình mạng lưới để sử dụng trong các bài test
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        entranceFee = config.entranceFee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        gasLane = config.gasLane;
        subscriptionId = config.subscriptionId;
        callbackGasLimit = config.callbackGasLimit;
    }

    /* Bài 27: Kiểm tra khởi tạo */
    function testRaffleInitializesInOpenState() public view {
        // Xác nhận trạng thái ban đầu của xổ số là OPEN (0) [1], [5]
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    /* Bài 29: Kiểm tra hàm enterRaffle */

    // 1. Kiểm tra revert khi người chơi không gửi đủ tiền phí
    function testRaffleRevertsWhenYouDontPayEnough() public {
        // Arrange (Chuẩn bị): Giả lập người chơi gọi hàm [6], [7]
        vm.prank(PLAYER);
        // Act / Assert (Hành động và Xác nhận): Mong đợi lỗi Raffle__NotEnoughEthSent [6], [7]
        vm.expectRevert(Raffle.Raffle__NotEnoughEthSent.selector);
        raffle.enterRaffle();
    }

    // 2. Kiểm tra việc ghi nhận địa chỉ người chơi khi tham gia thành công
    function testRaffleRecordsPlayerWhenTheyEnter() public {
        // Arrange
        vm.prank(PLAYER);
        // Act: Tham gia xổ số với đúng số tiền entranceFee [8], [9]
        raffle.enterRaffle{value: entranceFee}();
        // Assert: Lấy địa chỉ tại index 0 và so sánh với PLAYER [8], [9]
        address playerRecorded = raffle.getPlayer(0);
        assert(playerRecorded == PLAYER);
    }
}
