//
//  FlutterMainViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/14.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils
import Flutter

class FlutterMainViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Flutter"

        let rightBarButtonItem = UIBarButtonItem(title: "进入Flutter", style: .plain, target: self, action: #selector(action))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "methodChannel", title: "调用Flutter的MethodChannel"),
            BaseGroupTableMenuModel(code: "eventChannel", title: "调用Flutter的EventChannel"),
            BaseGroupTableMenuModel(code: "messageChannel", title: "调用Flutter的MessageChannel")
        ]
        menu.append(fisrtMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        guard let delegate = (UIApplication.shared.delegate as? ApplicationServiceManagerDelegate)?.getService(by: FlutterApplicationService.self) as? FlutterApplicationService else {
            return
        }
        let viewController = FlutterContentViewController(engine: delegate.flutterEngine, nibName: nil, bundle: nil)
        switch menuModel.code {
        case "methodChannel":
            guard let binaryMessenger = viewController as? FlutterBinaryMessenger  else {
                return
            }
            let channel = FlutterMethodChannel(name: FlutterConstants.getChannelName(type: .method, channelName: "testMethodChannel"), binaryMessenger: binaryMessenger)
            channel.invokeMethod("callFlutter", arguments: ["key": "来自Native的数据"]) { result in
                Log.d(result)
            }
        case "eventChannel":
            break
        case "messageChannel":
            break
        default:
            HUD.showText("暂无此模块")
        }
    }

    @objc
    func action() {
        guard let delegate = (UIApplication.shared.delegate as? ApplicationServiceManagerDelegate)?.getService(by: FlutterApplicationService.self) as? FlutterApplicationService else {
            return
        }
        /**
         在iOS模拟器下，第二次使用engin 创建FlutterViewContainer时， initWithEngine: 会crash，报错如下
         Thread 1: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
         原因是僵尸指针导致
         真机上不会出现
         */
        let viewController = FlutterContentViewController(engine: delegate.flutterEngine, nibName: nil, bundle: nil)
//        viewController.modalPresentationStyle = .fullScreen
        registerPlugins(viewController: viewController)
        navigationController?.present(viewController, animated: true, completion: nil)
    }
}

extension FlutterMainViewController {
    func registerPlugins(viewController: FlutterViewController) {
        registerMethodChannel(viewController: viewController)
        registerEventChannel(viewController: viewController)
        registerBasicMessageChannel(viewController: viewController)
        // 注册插件
        // GeneratedPluginRegistrant.register(with: self)
    }

    // MethodChannel
    func registerMethodChannel(viewController: FlutterViewController) {
        guard let binaryMessenger = viewController as? FlutterBinaryMessenger  else {
            return
        }
        let channel = FlutterMethodChannel(name: FlutterConstants.getChannelName(type: .method, channelName: "testMethodChannel"), binaryMessenger: binaryMessenger)
        channel.setMethodCallHandler { call, result in
            if call.method == "callNativeMethond" {
                let para = call.arguments
                Log.d(para)
                result(["key": "原生数据"])
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // EventChannel
    func registerEventChannel(viewController: FlutterViewController) {
        let channelName = "com.star.LTXiOSUtils/event"
        guard let binaryMessenger = viewController as? FlutterBinaryMessenger  else {
            return
        }
        let channel = FlutterEventChannel(name: channelName, binaryMessenger: binaryMessenger)
    }

    // BasicMessageChannel
    // 相对与其他Channel类型的创建，MessageChannel的创建除了channel名以外，还需要指定编码方式
    /**
     BinaryCodec 发送二进制消息时
     JSONMessageCodec 发送Json格式消息时
     StandardMessageCodec 发送基本型数据时
     StringCodec 发送String类型消息时
     */
    func registerBasicMessageChannel(viewController: FlutterViewController) {
        let channelName = "com.star.LTXiOSUtils/basicMessage"
        guard let binaryMessenger = viewController as? FlutterBinaryMessenger  else {
            return
        }
        let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: FlutterStringCodec())
        channel.setMessageHandler { call, result in
            Log.d(call)
            result("结果")
        }

    }

}

extension FlutterMainViewController: FlutterPluginRegistry {
    func registrar(forPlugin pluginKey: String) -> FlutterPluginRegistrar? {
        Log.d(pluginKey)
        return nil
    }

    func hasPlugin(_ pluginKey: String) -> Bool {
        Log.d(pluginKey)
        return true
    }

    func valuePublished(byPlugin pluginKey: String) -> NSObject? {
        Log.d(pluginKey)
        return nil
    }
}
