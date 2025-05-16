// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {IClaimableLink} from "@claimable-link/interfaces/IClaimableLink.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {UnclaimedLinks, IMulticall3} from "src/libraries/UnclaimedLinks.sol";

contract BatchRefundTest is Test {
    uint256 arbitrumFork;

    IERC20 usdcContract;
    IClaimableLink claimableLinkContract;
    IMulticall3 multiCall3Contract;

    address usdcAddress;
    address claimableLinkAddress;
    address multiCall3Address;

    address giver;
    address relayer;

    function setUp() public {
        arbitrumFork = vm.createFork(vm.envString("ARB_MAINNET_NODE_RPC_URL"));

        vm.selectFork(arbitrumFork);
        vm.rollFork(333_333_333);

        usdcContract = IERC20(0xaf88d065e77c8cC2239327C5EDb3A432268e5831);
        claimableLinkContract = IClaimableLink(0x79EE808918cc91Cca19454206dc7027e4fa4A473);
        multiCall3Contract = IMulticall3(0xcA11bde05977b3631167028862bE2a173976CA11);

        giver = 0x1234A72239ecbA742D9A00C6Bec87b5a4ABF481a;
        relayer = makeAddr("relayer");

        usdcAddress = address(usdcContract);
        claimableLinkAddress = address(claimableLinkContract);
        multiCall3Address = address(multiCall3Contract);

        vm.deal(relayer, 1000 ether);
    }

    function testBatchRefund() public {
        IMulticall3.Call[] memory multicall3Call = UnclaimedLinks.buildAggregateCalldata();

        uint256 giverUsdcBalanceBefore = usdcContract.balanceOf(giver);
        uint256 claimableLinkBalanceBefore = usdcContract.balanceOf(claimableLinkAddress);

        vm.startPrank(relayer);
        multiCall3Contract.aggregate(multicall3Call);
        vm.stopPrank();

        uint256 giverUsdcBalanceAfter = usdcContract.balanceOf(giver);
        uint256 claimableLinkBalanceAfter = usdcContract.balanceOf(claimableLinkAddress);

        assertEq(
            int256(claimableLinkBalanceAfter) - int256(claimableLinkBalanceBefore),
            -(int256(giverUsdcBalanceAfter) - int256(giverUsdcBalanceBefore))
        );
    }
}
