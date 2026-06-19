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

    function testRaffleInitializesInOpenState() public view {
        // Kiểm tra xem trạng thái khởi tạo có phải là OPEN không
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }
}
