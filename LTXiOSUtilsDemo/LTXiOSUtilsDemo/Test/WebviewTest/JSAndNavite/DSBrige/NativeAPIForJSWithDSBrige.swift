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

class NativeAPIForJSWithDSBrige {

    /**
     异步时使用闭包
     Any表示回传到JS的数据
     Bool表示是否回传完毕，如果设置成true，表示数据已经回传完毕，js不会再接收来自原生的数据，
     设置为false，表示js会继续接收来自原生的数据
     */
    typealias JSCallback = (_ dataToJS: Any, _ endSendData: Bool) -> Void

    private init() {}
    /// 单例
    public static let shared = NativeAPIForJSWithDSBrige()

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
    func callNativeAsync(_ arg: Any, hander: @escaping JSCallback) {
        Log.d(arg)
        let result = ["type": "异步", "message": "从Native返回的异步数据"]

        // 模仿耗时操作
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            hander(result, true)
        }
    }

    // js调用原生，获取进度，JS调用原生的异步任务实际上是Native通过定时器不断去执行JS的回调函数，定时器周期为50ms，当异步任务的频率大于此频率时，就会出现问题
    @objc
    func callProgress(_ arg: Any, hander: @escaping JSCallback) {
        Log.d(arg)
        var value = 1
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if value > 10 {
                timer.invalidate()
                hander("结束", true)
            } else {
                hander(value, false)
                value += 1
            }
        }
    }

}
