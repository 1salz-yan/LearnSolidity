// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
contract ABIEncoder {    
    function encodeUint(uint256 value) public pure returns (bytes memory) {
        return abi.encode(value);    
    }    
    function encodeMultiple(uint num, string memory text) public pure returns (bytes memory) {
               return abi.encode(num, text);
    }
}
contract ABIDecoder {    
    function decodeUint(bytes memory data) public pure returns (uint) { 
        return abi.decode(data, (uint));
        //注意这里必须是tuple of types的形式
    }    
    function decodeMultiple(bytes memory data) public pure returns (uint, string memory) {        
        return abi.decode(data, (uint, string));    
        }
    }