//
//  OC-Swift.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/6/28.
//  Copyright © 2020 李天星. All rights reserved.
//

/*
 当class是NSObject的子类时，这个类便可以在 "Product Name-Swift.h"中 找到，默认携带 init 构造方法,这个Product Name是在Build Settings 可以看到
 当类中的 非private以及非fileprivate 方法以及变量被 @objc 修饰时，该变量或者方法便可以在 "Product Name-Swift.h"中 找到
 当在类上添加 @objcMembers 修饰时，该类中所有的 非private以及非fileprivate 方法以及变量 都可以在 "Product Name-Swift.h"中 找到
 如果需要OC与Swift中类、方法以及属性的名字不一致，可以在@objc(OCName)这种形式为OC单独定义名称，比如当swift中的类为中文时
 */

/*
 在swift 4之前，如果类继承了NSObject，编译器就会默认给这个类中的所有函数都标记为@objc，支持OC调用。
 苹果在Swift4中，修改了自动添加@objc的逻辑：
    一个继承NSObject的Swift类不在默认给所有函数添加@objc。只在实现OC接口和重写OC方法时，才自动给函数添加@objc标识。
 */

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

@objc
protocol OCSwiftProtocol {
    func show()
}
