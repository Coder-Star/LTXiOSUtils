//
//  KeychainAccessTest.swift
//  LTXiOSUtilsDemoTests
//
//  Created by 李天星 on 2020/1/10.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import KeychainAccess
import QorumLogs

@testable import KeychainAccess

class KeychainAccessTest: XCTestCase {

    let keychain = Keychain(service: "com.coderstar.ltxiosutilsdemo").accessibility(.afterFirstUnlock)

    func test() {
//        save()
        get()
        remove()
    }

    func save() {
        keychain[string:"info"] = "处理"
    }

    func get() {
        Log.d(keychain[string:"info"])
        Log.d(keychain[string:"info1"])
    }

    func remove() {
        try? keychain.remove("info")
    }
}


