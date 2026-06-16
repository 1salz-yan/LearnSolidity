// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Callee {
    uint256 public value;

    function setValue(uint256 _newValue) public {
        value = _newValue;
    }
}

contract Caller {
    uint256 public value;

    function delegateSetValue(address callee, uint256 _newValue) public {
        // delegatecall setValue()
        bytes memory playload = abi.encodeWithSignature("setValue(string)", _newValue);

        (bool success, ) = callee.call(playload);
        require(success, "delegate call failed");
    }
}
