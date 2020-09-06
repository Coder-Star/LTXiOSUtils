//
//  CodecTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/9/3.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import LTXiOSUtils

/**
 在iOS中编解码的方式大概分为两种，NSCoding协议以及Codable协议
 其中NSCoding为OC的方式，需要实现编码、解码两个方法，并且必须继承NSObject
 Codable为swift4.0引入的新协议
 */

class NSCodecModel: NSObject, NSSecureCoding {

    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    static var supportsSecureCoding: Bool {
        return true
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(age, forKey: "age")
    }

    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        age = coder.decodeInteger(forKey: "age")
    }

    override var description: String {
        return "name:\(name),age=\(age)"
    }
}

class CodecModel: Codable {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

extension CodecModel: CustomStringConvertible {
    var description: String {
        return "name:\(name),age=\(age)"
    }
}

/**
 对数据进行编解码的工具包含 PropertyList、JSON以及NSKeyed
 同样的对象，生成的文件大小从小到达依次为 JSON < PropertyList < NSKeyed
 JSON、PropertyList只能编码实现Codable协议的模型
 虽然网上都说实现Coable的模型也可以无缝使用归解档，但是经过我实际的测试，发现根本不行，除非先使用PropertyList或者JSON先将模型转换为data，然后再将data进行归档，接档时先解档成data，然后再将data转为模型，但是这样完全是多此一举
 */
class CodecTest: XCTestCase {

    let model = CodecModel(name: "CodecModel", age: 10)
    let nsModel = NSCodecModel(name: "NSCodecModel", age: 20)

    /**
     对象实例与 XML 数据格式之间进行互相转换
     */
    func testPropertyListEncoderDemo() {

        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("CodecModel").appendingPathExtension("plist")
        Log.d(url)
        let encoder = PropertyListEncoder()
        // outputFormat不影响实际存储，只影响取值时的显示
        encoder.outputFormat = .xml
        let encodeModelData = try? encoder.encode(model)
        try? encodeModelData?.write(to: url)
        Log.d(String(data: encodeModelData!, encoding: .utf8))

        let decodeModel = try? PropertyListDecoder().decode(CodecModel.self, from: encodeModelData!)
        Log.d(decodeModel)
    }

    /**
     对象实例与 JSON 数据格式之间进行互相转换
     */
    func testJSONEncoderDemo() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("CodecModel").appendingPathExtension("json")
        Log.d(url)
        let encoder = JSONEncoder()
         // outputFormatting不影响实际存储，只影响取值时的显示
        encoder.outputFormatting = .prettyPrinted
        let encodeModelData = try? encoder.encode(model)
        try? encodeModelData?.write(to: url)
        Log.d(String(data: encodeModelData!, encoding: .utf8))


        let decodeModel = try? JSONDecoder().decode(CodecModel.self, from: encodeModelData!)
        Log.d(decodeModel)
    }

    func testKeyedArchiverEncoderDemo() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("CodecModelArchived").appendingPathExtension("plist")
        Log.d(url)
        do {
            let jsonData = try JSONEncoder().encode(model)
            let data = try NSKeyedArchiver.archivedData(withRootObject: jsonData, requiringSecureCoding: false)
            try data.write(to: url)

            let decodeJSONData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data
            let decodeModel = try JSONDecoder().decode(CodecModel.self, from: decodeJSONData!)
            Log.d(decodeModel)
        } catch let error {
            Log.d(error)
        }

        let nsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("NSCodecModel").appendingPathExtension("plist")

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: nsModel, requiringSecureCoding: true)
            try data.write(to: nsUrl)
            let decodeModel = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSCodecModel
            Log.d(decodeModel)
        } catch let error {
            Log.d(error)
        }
    }
}
