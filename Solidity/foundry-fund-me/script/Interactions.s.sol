//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "src/FundMe.sol";

//Fund
//Withdraw

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address mostRecentlyDeployee) public {
        FundMe(payable(mostRecentlyDeployee)).fund{value: 0.1 ether}();
        console.log("Funded the contract with $", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployee) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployee)).withdraw();
        vm.stopBroadcast();
        // After withdrawal, the balance of the contract should be zero
        console.log("Withdrawn funds from the contract");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        WithdrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}
