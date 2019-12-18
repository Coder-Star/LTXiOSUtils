//
//  AuthorizedTargetType.swift
//  LTXiOSUtils
//  自定义的TargetType
//  Created by 李天星 on 2019/9/4.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
import Moya

public protocol CustomizeTargetType: TargetType {
    /// 返回是否需要授权
    var needAuth: Bool { get }

    ///等待框相关
    var hudConfig: HudConfig { get }

}
