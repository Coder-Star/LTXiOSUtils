//
//  MGJRouterDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/4/21.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import UIKit
import MGJRouter

class MGJRouterDemoViewController: BaseUIViewController {

    var content = ""

    private lazy var contentTextView: UITextView = {
        let contentTextView = UITextView()
        contentTextView.font = UIFont.systemFont(ofSize: 17)
        contentTextView.textColor = .red
        contentTextView.layer.borderColor = UIColor.red.cgColor
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.cornerRadius = 5
        return contentTextView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "组件详情"
        contentTextView.text = content
        baseView.add(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
    }
}

extension MGJRouterDemoViewController {

    static let routerPrefix = "ltx://"

    class func registerRouter() {
        // swiftlint:disable trailing_closure
        // 基本使用，传入字典、传递自定义参数(首个参数带形参名)
        MGJRouter.registerURLPattern(routerPrefix + "MGJRouterDemo", toHandler: { routerParameters in
            Log.d("基本使用，传入字典、传递自定义参数(首个参数带形参名)")
            printToHandlerInfo(routerParameters: routerParameters)
        })

        // 路径中含有中文
        MGJRouter.registerURLPattern(routerPrefix + "category/购物", toHandler: { routerParameters in
            Log.d("路径中含有中文")
            printToHandlerInfo(routerParameters: routerParameters)
        })

        // 传递自定义参数(首个参数不带形参名)
        MGJRouter.registerURLPattern(routerPrefix + "MGJRouterDemo/:content", toHandler: { routerParameters in
            Log.d("传递自定义参数(首个参数不带形参名)")
            if let result = routerParameters, let content = result["content"] {
                let viewController = MGJRouterDemoViewController()
                viewController.content = content as? String ?? "content为空"
                /// 这里还可以通过另外一种方式，自定义navigationController，获取顶部的UIViewController进行跳转
                UIViewController.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
            }
            printToHandlerInfo(routerParameters: routerParameters)
        })

        // 全局的URL Pattern
        // 类似一个default操作
        MGJRouter.registerURLPattern(routerPrefix, toHandler: { routerParameters in
            Log.d("全局的URL Pattern")
            printToHandlerInfo(routerParameters: routerParameters)
        })

        // opneUrl结束执行Completion Block
        MGJRouter.registerURLPattern(routerPrefix + "MGJRouterDemoBlock", toHandler: { routerParameters in
            Log.d("opneUrl结束执行Completion Block")
            if let result = routerParameters, let block = result[MGJRouterParameterCompletion] {
                // 将block转为closure
                typealias CallbackType = @convention(block) (Any?) -> Void
                let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
                let callback = unsafeBitCast(blockPtr, to: CallbackType.self)

                if let userInfo = result[MGJRouterParameterUserInfo] as? [String: String] {
                    let viewController = MGJRouterDemoViewController()
                    viewController.content = userInfo["content"] ?? "content为空"
                    callback(viewController)
                }
            }
            printToHandlerInfo(routerParameters: routerParameters)
        })

        // 同步获取URL对应的Object
        MGJRouter.registerURLPattern(routerPrefix + "MGJRouterDemoObject", toObjectHandler: { routerParameters in
            Log.d("同步获取URL对应的Object")
            var content = ""
            if let result = routerParameters, let block = result[MGJRouterParameterCompletion] {
                // 将block转为closure
                typealias CallbackType = @convention(block) (Any?) -> Void
                let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
                let callback = unsafeBitCast(blockPtr, to: CallbackType.self)
                if let userInfo = result[MGJRouterParameterUserInfo] as? [String: String] {
                    let viewController = MGJRouterDemoViewController()
                    content = userInfo["content"] ?? "content为空"
                    viewController.content = content
                    callback(viewController)
                }
            }
            printToHandlerInfo(routerParameters: routerParameters)
            return "获取URL对应的Object成功"
        })

        // 取消url的注册
//        MGJRouter.deregisterURLPattern("")

    }
}

extension MGJRouterDemoViewController {
    class func printToHandlerInfo(routerParameters: [AnyHashable: Any]?) {
        Log.d(routerParameters)
        if let result = routerParameters {
            if let url = result[MGJRouterParameterURL] as? String {
                Log.d("MGJRouterParameterURL")
                Log.d(url)
                Log.d(url.tx.urlDecode)
            }
            if let userInfo = result[MGJRouterParameterUserInfo] {
                Log.d("MGJRouterParameterUserInfo")
                Log.d(userInfo)
            }
            if let completion = result[MGJRouterParameterCompletion] {
                Log.d("MGJRouterParameterCompletion")
                Log.d(completion)
            }
        }
    }
}
