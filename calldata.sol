// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataStorage {
    string private data;
    //private 的意思是：别的合约不能这样直接读：dataStorage.data()

    function setData(string memory newData) public {
        data = newData;
    }

    function getData() public view returns (string memory) {
        return data;
        //虽然 data 是 private，但外部还是可以通过 getData() 读取它。
    }
}

contract DataConsumer {
    address private dataStorageAddress;

    constructor(address _dataStorageAddress) {
        dataStorageAddress = _dataStorageAddress;
    }
    //把外部传进来的 DataStorage 合约地址，记录到本合约里

    function getDataByABI() public returns (string memory) {
        // payload
        bytes memory payload = abi.encodeWithSignature("getData()");
        //把getData()函数签名进行abi编码，赋值给payload，这句生成getData()的calldata
        
        (bool success, bytes memory data) = dataStorageAddress.call(payload);
        require(success, "call function failed");
        //低级调用dataStorageAddress这个地址的call函数，传入payload，返回success和data，因为此处的data是bytes所以还要进行decode
        
        // return data
        return abi.decode(data, (string));
    }

    function setDataByABI1(string calldata newData) public returns (bool) {
        // playload
        bytes memory payload = abi.encodeWithSignature("setData(string)", newData);
        //把setData(string)函数签名和newData进行abi编码，赋值给payload
        //因为setData(string)函数需要传入参数，所以需要在encodeWithSignature中添加newData
        //完整 calldata 大概是：函数选择器 + 参数编码

        (bool success, ) = dataStorageAddress.call(payload);
        require(success, "call function failed");

        return success;
    }

    function setDataByABI2(string calldata newData) public returns (bool) {
        // selector
        bytes4 selector = bytes4(keccak256(bytes("setData(string)")));
        // 计算函数签名的keccak256哈希值，并取前4个字节作为函数选择器，本质上和bytes memory payload = abi.encodeWithSignature("setData(string)", newData);这个步骤是一样的

        // playload
        bytes memory payload = abi.encodeWithSelector(selector, newData);

        (bool success, ) = dataStorageAddress.call(payload);

        return success;
    }

    function setDataByABI3(string calldata newData) public returns (bool) {
        // playload
        bytes memory playload = abi.encodeWithSignature("setData(string)", newData);

        (bool success, ) = dataStorageAddress.call(playload);
        return success;
    }
}

//根据函数签名字符串生成 calldata：abi.encodeWithSignature("setData(string)", newData) 
//根据已经算好的 selector 生成 calldata：abi.encodeWithSelector(selector, newData)
//把 calldata 发给目标合约执行：address.call(payload)
//把返回的 bytes 解码成 Solidity 类型：abi.decode(data, (string))
//这段代码最核心的学习点是：合约调用 = 目标地址 + calldata；calldata = 4 字节 function selector + ABI 编码后的参数

//abi.encode(...)              只编码数据
//abi.encodePacked(...)        紧密打包数据
//abi.encodeWithSignature(...) selector + 参数(Solidity底层自动帮你计算Selctor)
//abi.encodeWithSelector(...)  selector + 参数
//abi.encodeCall(...)          类型安全的 selector + 参数
//接口调用                     高级封装，日常最常用
//call(payload)                把 calldata 发给目标地址
//abi.decode(...)              解码返回值