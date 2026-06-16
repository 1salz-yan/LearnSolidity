// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Caller {
    function sendEther(address to, uint256 value) public returns (bool) {
        // 使用 call 发送 ether
        (bool success, ) = payable(to).call{value: value}("");
        // 确保发送成功，这一步是关键
        require(success, "sendEther failed");

        return success;
    }

    receive() external payable {}
    //有payable让Caller合约本身才能接受eth
}