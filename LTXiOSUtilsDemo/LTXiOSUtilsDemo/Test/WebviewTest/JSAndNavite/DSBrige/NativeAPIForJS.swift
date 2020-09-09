//
//  NativeAPIForJS.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/9.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

/*
 注意事项
 arg这个参数必不可少，不可因为传的参数是空就不写形参，如果不写会直接报错
 方法前必须加上 @objc 关键字
 */

class NativeAPIForJS {

    typealias JSCallback = (Any, Bool) -> Void

    private init() {}
    /// 单例
    public static let shared = NativeAPIForJS()

    // 可多级设置，方便区分层级
    static let nameSpace = "app.common"

    // js调用原生，同步
    @objc
    func callNativeSync(_ arg: Any) -> Any {
        Log.d(arg)
        return ["type": "同步", "message": "从Native返回的同步数据"]
    }

    // js调用原生，异步
    @objc
    func callNativeAsync(_ arg: Any, hander: JSCallback) {
        Log.d(arg)
        let result = ["type": "异步", "message": "从Native返回的异步数据"]
        hander(result, true)
    }

}
