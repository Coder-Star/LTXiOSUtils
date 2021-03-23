//
//  PlistTest.swift
//  LTXiOSUtilsDemoTests
//  writeToFile plist文件存储
//  Created by 李天星 on 2020/8/30.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils

// writeToFile的方式无法直接存储自定义对象，即使实现了NSCoding协议
// 如果想存储自定义对象，需要使用解归档，或者将对象转换成json字符串进行存储

class PlistTest: XCTestCase {

    func test() {
        let fileManager = FileManager.default
        let path = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
        Log.d(path)

        // NSMutableArray、NSArray
        let listPath = path.appendingPathComponent("list").appendingPathExtension("plist")
        let list = NSMutableArray()
        let one = ["姓名": "张三", "年龄": 24] as [String : Any]
        list.add(one)
        if !fileManager.fileExists(atPath: listPath.absoluteString) {
            Log.d(list.write(toFile: listPath.path, atomically: true))
        } else {
            let fileHandle = FileHandle(forUpdatingAtPath: listPath.absoluteString)
            fileHandle?.seekToEndOfFile()
            let data = try? JSONSerialization.data(withJSONObject: list, options: [])
            fileHandle?.write(data!)
            fileHandle?.closeFile()
        }
        Log.d(NSArray(contentsOf: listPath))

        // NSData、Data、NSMutableData
        let nsDataPath = path.appendingPathComponent("nsData").appendingPathExtension("plist")
        let nsData = NSData(data: "这NSData".data(using: .utf8)!)
        NSData(contentsOf: <#T##URL#>)
        nsData.write(to: nsDataPath, atomically: true)
        Log.d(String(data: NSData(contentsOf: nsDataPath)! as Data, encoding: .utf8))

        // String、NSString
        let stringPath = path.appendingPathComponent("string").appendingPathExtension("plist")
        let str = "123"
        try? str.write(toFile: stringPath.path, atomically: true, encoding: .utf8)
        Log.d(try? String(contentsOf: stringPath))

        // NSDictionary、NSMutableDictionary
        let dicPath = path.appendingPathComponent("dic").appendingPathExtension("plist")
        let dic = ["姓名": "张三", "年龄": 24] as [String : Any]
        NSDictionary(dictionary: dic).write(to: dicPath, atomically: true)
        Log.d(NSDictionary(contentsOf: dicPath))
    }
}
