// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FunctionSelector {
    uint256 private storedValue;

    function getValue() public view returns (uint) {
        return storedValue;
    }

    function setValue(uint value) public {
        storedValue = value;
    }

    function getFunctionSelector1() public pure returns (bytes4) {
        return bytes4(keccak256("getValue()"));
        //return this.getValue.selector;
    }

    function getFunctionSelector2() public pure returns (bytes4) {
        return bytes4(keccak256("setValue(uint256)"));
        //注意这里要写标准的规范形式uint256而不仅仅是uint，函数签名的规范，并且如果有两个类型名逗号之间无间隔
        //return this.setValue.selector;
    }
    }
