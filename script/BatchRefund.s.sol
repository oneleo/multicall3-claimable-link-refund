// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script, console} from "forge-std/Script.sol";
import {UnclaimedLinks, IMulticall3} from "src/abstract/UnclaimedLinks.sol";

contract BatchRefundScript is Script, UnclaimedLinks {
    IMulticall3 private _multiCall3Contract = IMulticall3(0xcA11bde05977b3631167028862bE2a173976CA11);

    function run() external {
        IMulticall3.Call[] memory multicall3Call = buildAggregateCalldata();

        vm.startBroadcast();
        _multiCall3Contract.aggregate(multicall3Call);
        vm.stopBroadcast();
    }
}
