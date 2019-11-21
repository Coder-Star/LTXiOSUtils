//
//  DefaultsKeys+Extension.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/11/21.
//  Copyright © 2019 李天星. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let launchCount = DefaultsKey<Int>("launchCount",defaultValue: 0)
    //    struct Login {
    //        static let username = DefaultsKey<String>("username",defaultValue:"这是默认值")
    //    }
}
