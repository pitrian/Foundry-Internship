// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {
    IVRFCoordinatorV2Plus
} from "@chainlink/contracts/src/v0.8/vrf/dev/interfaces/IVRFCoordinatorV2Plus.sol";
import {
    VRFV2PlusClient
} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract VRFCoordinatorV2PlusMock is IVRFCoordinatorV2Plus {
    uint96 private s_baseFee;
    uint96 private s_gasPriceLink;
    uint256 private s_currentSubId;
    uint256 private s_nonce;

    struct Subscription {
        address owner;
        uint96 balance;
        uint96 nativeBalance;
    }
    mapping(uint256 => Subscription) private s_subscriptions;

    constructor(uint96 _baseFee, uint96 _gasPriceLink) {
        s_baseFee = _baseFee;
        s_gasPriceLink = _gasPriceLink;
    }

    function createSubscription() external override returns (uint256 subId) {
        s_currentSubId++;
        s_subscriptions[s_currentSubId] = Subscription(msg.sender, 0, 0);
        return s_currentSubId;
    }

    function getSubscription(
        uint256 subId
    )
        external
        view
        override
        returns (
            uint96 balance,
            uint96 nativeBalance,
            uint64 reqCount,
            address owner,
            address[] memory consumers
        )
    {
        address[] memory mockConsumers = new address[](0);
        return (
            s_subscriptions[subId].balance,
            s_subscriptions[subId].nativeBalance,
            0,
            s_subscriptions[subId].owner,
            mockConsumers
        );
    }

    function fundSubscription(uint256 subId, uint96 amount) external {
        s_subscriptions[subId].balance += amount;
    }

    function requestRandomWords(
        VRFV2PlusClient.RandomWordsRequest calldata req
    ) external override returns (uint256 requestId) {
        s_nonce++;
        return uint256(keccak256(abi.encodePacked(msg.sender, s_nonce)));
    }

    function acceptSubscriptionOwnerTransfer(uint256) external pure override {}
    function addConsumer(uint256, address) external pure override {}
    function cancelSubscription(uint256, address) external pure override {}
    function fundSubscriptionWithNative(uint256) external payable override {}
    function getActiveSubscriptionIds(
        uint256,
        uint256
    ) external pure override returns (uint256[] memory) {
        return new uint256[](0);
    }
    function pendingRequestExists(
        uint256
    ) external pure override returns (bool) {
        return false;
    }
    function removeConsumer(uint256, address) external pure override {}
    function requestSubscriptionOwnerTransfer(
        uint256,
        address
    ) external pure override {}
}
