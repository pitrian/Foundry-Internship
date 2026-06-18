// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
// import {VRFCoordinatorV2PlusMock} from "chainlink/src/v0.8/vrf/mocks/VRFCoordinatorV2PlusMock.sol";
// import {
//     VRFCoordinatorV2PlusMock
// } from "../test/mocks/VRFCoordinatorV2PlusMock.sol";
// import {LinkToken} from "../test/mocks/LinkToken.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint256 subscriptionId;
        uint32 callbackGasLimit;
        address link;
        uint256 deployerKey;
    }

    NetworkConfig public activeNetworkConfig;

    uint96 public constant MOCK_BASE_FEE = 0.25 ether;
    uint96 public constant MOCK_GAS_PRICE_LINK = 1e9;
    int256 public constant MOCK_WEI_PER_UNIT_LINK = 4e15;

    constructor() {
        // Tự động chọn cấu hình dựa trên Chain ID
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    // Cấu hình cho mạng thử nghiệm Sepolia
    function getSepoliaEthConfig() public view returns (NetworkConfig memory) {
        return
            NetworkConfig({
                entranceFee: 0.01 ether,
                interval: 30, //30 giây
                vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
                gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
                subscriptionId: 0, // Cập nhật ID của bạn tại đây
                callbackGasLimit: 500000,
                link: 0x779877A7B0D9E8603169DdbD7836e478b4624789,
                deployerKey: vm.envUint("PRIVATE_KEY")
            });
    }

    // Cấu hình cho mạng local Anvil
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // Nếu đã có cấu hình coordinator (đã tạo Mock), trả về luôn
        if (activeNetworkConfig.vrfCoordinator != address(0)) {
            return activeNetworkConfig;
        }

        // vm.startBroadcast();
        // VRFCoordinatorV2PlusMock vrfCoordinatorMock = new VRFCoordinatorV2PlusMock(
        //         MOCK_BASE_FEE,
        //         MOCK_GAS_PRICE_LINK
        //     );
        // LinkToken link = new LinkToken();
        // vm.stopBroadcast();

        // Bài 23 thiết lập khung sườn, Bài 24 sẽ hướng dẫn triển khai Mocks tại đây
        return
            NetworkConfig({
                entranceFee: 0.01 ether,
                interval: 30,
                vrfCoordinator: address(0), // Sẽ thay bằng Mock ở bài 24 //address(vrfCoordinatorMock),
                gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
                subscriptionId: 0,
                callbackGasLimit: 500000,
                // link: address(link),
                deployerKey: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 // Anvil default key
            });
    }
    // Hàm Getter để lấy cấu hình hiện tại [8]
    function getConfig() public view returns (NetworkConfig memory) {
        return activeNetworkConfig;
    }
}
