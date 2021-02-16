//
//  KeyedArchiverTest.swift
//  LTXiOSUtilsDemoTests
//  解归档测试
//  Created by 李天星 on 2020/8/30.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils

// 只有继承自NSObject并且遵守了NSCoding协议的类才可以进行相应的归档操作，为什么必须继承NSObject的原因应该是因为swift还没有实现解归档的协议
class ArchiverUser:NSObject, NSCoding {
    var name: String
    var phone: String

    init(name: String, phone: String) {
        self.name = name
        self.phone = phone
    }

    /**
     下列两个方法是NSCoding规定的协议方法，用来映射关系，可以利用runtime统一映射。class_copyIvarList
     */

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey:"Name")
        coder.encode(phone, forKey:"Phone")
    }

    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "Name") as? String ?? ""
        phone = coder.decodeObject(forKey: "Phone") as? String ?? ""
    }
}

// 在ios12以上，由继承NSCoding改为继承NSSecureCoding协议，NSSecureCoding协议也是继承自NSCoding
// NSSecureCoding主要是用于加强安全性的, NSSecureCoding要求实现一个supportsSecureCoding的bool值
class ArchiverSecureUser: NSObject, NSSecureCoding {

    var name: String
    var phone: String

    init(name: String, phone: String) {
        self.name = name
        self.phone = phone
    }

    static var supportsSecureCoding: Bool {
        return true
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey:"Name")
        coder.encode(phone, forKey:"Phone")
    }

    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "Name") as? String ?? ""
        phone = coder.decodeObject(forKey: "Phone") as? String ?? ""
    }


}

class KeyedArchiverByNSCodingTest: XCTestCase {

    /**
     ArchiverUser.archiver是无法被正常解压到，内部进行了加密
     */
    func testSaveAndRead() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/ArchiverUser.archiver")

        Log.d(path)
        
        if #available(iOS 12, *) {
            let user1 = ArchiverSecureUser(name: "张三", phone: "123")
            let user2 = ArchiverSecureUser(name: "李四", phone: "234")
            var list = Array<ArchiverSecureUser>()
            list.append(user1)
            list.append(user2)
            do {
                let fileUrl = URL(fileURLWithPath: path)

                // 归档
                let data = try NSKeyedArchiver.archivedData(withRootObject: list, requiringSecureCoding: true)
                try data.write(to: fileUrl)

                // 解档
                let fileData = try Data(contentsOf: fileUrl)
                let info = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as? Array<ArchiverSecureUser>
                Log.d(info![0].name)
            } catch let error {
                Log.d(error)
            }

        } else {
            let user1 = ArchiverUser(name: "张三", phone: "123")
            let user2 = ArchiverUser(name: "李四", phone: "234")
            var list = Array<ArchiverUser>()
            list.append(user1)
            list.append(user2)

            NSKeyedArchiver.archiveRootObject(list, toFile: path)

            let info = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Array<ArchiverUser>
            Log.d(info![0].name)
        }
    }

}
