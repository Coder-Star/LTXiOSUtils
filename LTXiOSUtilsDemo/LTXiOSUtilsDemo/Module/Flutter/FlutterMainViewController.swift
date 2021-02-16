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
import SwiftyJSON

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
                HUD.showText(String(describing: result))
            }
        case "eventChannel":
            guard let binaryMessenger = viewController as? FlutterBinaryMessenger  else {
                return
            }
            let channel = FlutterEventChannel(name: FlutterConstants.getChannelName(type: .event, channelName: "testEventChannel"), binaryMessenger: binaryMessenger)
            channel.setStreamHandler(self)
        case "messageChannel":
            guard let binaryMessenger = viewController as? FlutterBinaryMessenger  else {
                return
            }
            // 需要指定编码器
            let channel = FlutterBasicMessageChannel(name: FlutterConstants.getChannelName(type: .basicMessage, channelName: "testMessageChannel"), binaryMessenger: binaryMessenger, codec: FlutterStringCodec())
            channel.sendMessage("来自Native的Message") { result in
                HUD.showText(String(describing: result))
            }

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
        registerPlugins(viewController: viewController)
        navigationController?.present(viewController, animated: true, completion: nil)
    }
}

extension FlutterMainViewController {

    /// 注册插件
    func registerPlugins(viewController: FlutterViewController) {
        registerMethodChannel(viewController: viewController)
        registerEventChannel(viewController: viewController)
        registerBasicMessageChannel(viewController: viewController)
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
                result(JSON(["key": "原生数据"]).description)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
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
        guard let binaryMessenger = viewController as? FlutterBinaryMessenger  else {
            return
        }
        let channel = FlutterBasicMessageChannel(name: FlutterConstants.getChannelName(type: .basicMessage, channelName: "testMessageChannel"), binaryMessenger: binaryMessenger, codec: FlutterStringCodec())
        channel.setMessageHandler { message, result in
            Log.d(message)
            result("来自Native的messageHandler")
        }

    }

}

extension FlutterMainViewController: FlutterStreamHandler {
    // EventChannel
    func registerEventChannel(viewController: FlutterViewController) {
        guard let binaryMessenger = viewController as? FlutterBinaryMessenger  else {
            return
        }
        let channel = FlutterEventChannel(name: FlutterConstants.getChannelName(type: .event, channelName: "testEventChannel"), binaryMessenger: binaryMessenger)
        channel.setStreamHandler(self)
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        events(0)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
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
