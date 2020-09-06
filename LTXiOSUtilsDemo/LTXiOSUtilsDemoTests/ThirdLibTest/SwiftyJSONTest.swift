//
//  SwiftyJSONTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/9/1.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XCTest
import SwiftyJSON
import LTXiOSUtils

class SwiftyJSONTest: XCTestCase {

    func test() {

        /**
         只能将Foundation对象转换成JSON。
         即顶层对象必须是Array或者Dictionary，所有的对象必须是String、Number、Array、Dictionary、Nil的实例。
         如果想将自定义对象转成JSON需要借助Codable或者NSCoding协议
         */

        // MARK: - SwiftyJSON
        let jsonStr = "[{\"ID\":1,\"Name\":\"元台禅寺\",\"LineID\":1},{\"ID\":2,\"Name\":\"田坞里山塘\",\"LineID\":1},{\"ID\":3,\"Name\":\"滴水石\",\"LineID\":1}]"
        Log.d(JSON(parseJSON: jsonStr))
        
        Log.d(JSON(parseJSON: jsonStr).rawString())

        Log.d(try? JSON(data: "123".data(using: .utf8)!, options: [.fragmentsAllowed]))

        do {
            _ = try JSON(data: "123".data(using: .utf8)!)
        } catch let error {
            //报错信息：JSON text did not start with array or object and option to allow fragments not set
            Log.d(error)
        }

        /**
         当转换的对象为json字符串时，不要使用JSON()这个构造函数，而是使用JSON(parseJSON: "")这个构造函数
         */


        // MARK: - iOS原生

        // 将json字符串转为对象
        let data = jsonStr.data(using: .utf8)!
        let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        Log.d(json)

        /**
         options为JSONSerialization.ReadingOptions类型，其中包括以下几种选项
         1、mutableContainer 允许将数据解析成json对象后，修改其中的数据，即转换后的对象是一个可变对象
         2、mutableLeaves 使解析出来的json对象的叶子节点的属性变为NSMutableString
         3、fragmentsAllowed 允许被解析的json数据不是array或者dic包裹，可以是单个string值
         */

        // 将对象转换为json字符串
        // 这是将Foundation对象转换成Data的方式
        let dataFromJSON = try! JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
        Log.d(String(data: dataFromJSON, encoding: .utf8))

        /**
         options为JSONSerialization.WritingOptions类型，其中包括以下几种选项
         1、prettyPrinted json数据格式化
         2、sortedKeys 使用该选项会对字典中的keys进行排序,iOS11才提供
         3、fragmentsAllowed 允许被解析的json数据不是array或者dic包裹，可以是单个string值
         4、withoutEscapingSlashes iOS13才提供,
         */

        let str = "123"
        let array = [1, 2, 3]
        let dic = ["姓名": "张三", "年龄": "28"]
        Log.d(JSONSerialization.isValidJSONObject(str))
        Log.d(JSONSerialization.isValidJSONObject(array))
        Log.d(JSONSerialization.isValidJSONObject(dic))

        /**
         JSONSerialization.isValidJSONObject 判断一个对象是否可以转换成JSON，其中转换成功的条件如下

         顶级对象是一个NSArray或NSDictionary
         所有对象都是NSString，NSNumber，NSArray，NSDictionary或NSNull
         所有字典键都是NSStrings
         NSNumbers不是NaN或无穷大
         */

    }

}
