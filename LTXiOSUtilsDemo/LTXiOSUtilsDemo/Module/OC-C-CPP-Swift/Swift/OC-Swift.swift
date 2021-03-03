//
//  OC-Swift.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/6/28.
//  Copyright © 2020 李天星. All rights reserved.
//


import Foundation

@objcMembers
@objc(OCSwiftClassOCName)
class OCSwiftClass: NSObject {

    // MARK: - 变量

    @objc(infoOCName)
    var info: String?

    private var privateInfo: String?

    fileprivate var fileprivateInfo: String?

    // MARK: - 方法
    func show() {
    }

    /*
     该方法如果第一个参数不省略参数名生成的oc方法如下
        - (void)showWithContent:(NSString * _Nonnull)content info:(NSString * _Nonnull)info;
     可以看到会将第一个参数名拼接到方法名上去，如果想不拼接，就将第一个参数名使用下划线 _, 换为下划线之后为
        - (void)show:(NSString * _Nonnull)content info:(NSString * _Nonnull)info;
     */
    func show(_ content: String, info: String) {
    }

    private func privateShow() {
    }

    fileprivate func fileprivateShow() {
    }

}

/*
 swift枚举如果需要被oc调用时，需要加上@objc修饰，并且需要是Int类型
 */
@objc
enum OCSwiftEnum: Int {
    case left
}

/**
 swift协议如果需要被oc调用，直接加上@objc修饰
 */
@objc
protocol OCSwiftProtocol {
    func show()
}

/**
 oc无法调用swift struct，可选值这种swift特有结构
 */
