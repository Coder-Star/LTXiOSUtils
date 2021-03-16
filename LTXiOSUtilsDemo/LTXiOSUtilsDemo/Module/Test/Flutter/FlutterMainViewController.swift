//
//  FlutterMainViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/14.
//  Copyright © 2020 李天星. All rights reserved.
//

import Flutter
import Foundation
import LTXiOSUtils
import SwiftyJSON

class FlutterMainViewController: BaseGroupTableMenuViewController {
    var eventSink: FlutterEventSink?

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
            guard let binaryMessenger = viewController as? FlutterBinaryMessenger else {
                return
            }
            let channel = FlutterMethodChannel(name: FlutterConstants.getChannelName(type: .method, channelName: "testMethodChannel"), binaryMessenger: binaryMessenger)
            channel.invokeMethod("callFlutter", arguments: ["key": "来自Native的数据"]) { result in
                HUD.showText(String(describing: result))
            }
        case "eventChannel":
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                Log.d("定时")
                self.eventSink?("来自Native的Event")
                self.eventSink?(FlutterError(code: "ErrorCode", message: "message", details: "details")) //输出错误
//                self.eventSink?(FlutterEndOfEventStream) //输出结束
            }
            HUD.showText("已启动向Flutter发送消息，请进入Flutter->FlutterChannel")
        case "messageChannel":
            guard let binaryMessenger = viewController as? FlutterBinaryMessenger else {
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
        guard let binaryMessenger = viewController as? FlutterBinaryMessenger else {
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
    // 这种通信方式使用较少
    /**
     BinaryCodec 发送二进制消息时
     JSONMessageCodec 发送Json格式消息时
     StandardMessageCodec 发送基本型数据时
     StringCodec 发送String类型消息时
     */
    func registerBasicMessageChannel(viewController: FlutterViewController) {
        guard let binaryMessenger = viewController as? FlutterBinaryMessenger else {
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
        guard let binaryMessenger = viewController as? FlutterBinaryMessenger else {
            return
        }
        let channel = FlutterEventChannel(name: FlutterConstants.getChannelName(type: .event, channelName: "testEventChannel"), binaryMessenger: binaryMessenger)
        channel.setStreamHandler(self)
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        Log.d(arguments)
        eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
