//
//  JSAndNativeDSBrigeViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/7.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import WebKit
import LTXiOSUtils
import SwiftyJSON
import dsBridge

/**
 DSBrige基本原理是
 JS -> Native 通过promt
 Native -> JS evaluateJavaScript

 因为DSBrige需要借助promt进行通信，所以需要DWKWebView内部实现uiDelegate，所以一定不可以将uiDelegate的实现转换给其他类，如果想实现uiDelegate，则实现DWKWebView提供的dsuiDelegate
 */

class JSAndNativeDSBrigeViewController: WkWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        // 将DWKWebView的uiDelegate交给当前VC实现，实现协议为  WKUIDelegate
        (webView as? DWKWebView)?.dsuiDelegate = self
        (webView as? DWKWebView)?.setDebugMode(true)

        // 请求原生URL
        // (webView as? DWKWebView)?.loadUrl("")

        // 控制js
        // (webView as? DWKWebView)?.disableJavascriptDialogBlock(false)

        // 当js使用window.close()，会触发该监听器
        (webView as? DWKWebView)?.setJavascriptCloseWindowListener {
            HUD.showText("JS执行了window.close()")
        }

        setJavascriptObject()
        guard let htmlURL = Bundle.main.url(forResource: "JSAndNativeDSBrige", withExtension: "html") else {
            return
        }
        webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL)
        var count: UInt32 = 0
        Log.d(class_copyMethodList(NativeAPIForJSWithDSBrige.self, &count))
        Log.d(count)
    }

    private func initNavigation() {
        let rightBarItem = UIBarButtonItem(title: "调用JS操作", style: .plain, target: self, action: #selector(action))
        navigationItem.rightBarButtonItem = rightBarItem
    }

    private func setJavascriptObject() {
        (webView as? DWKWebView)?.addJavascriptObject(NativeAPIForJSWithDSBrige.shared, namespace: NativeAPIForJSWithDSBrige.nameSpace)
    }

    @objc
    func action() {
        let alertController = UIAlertController(title: "选项", message: "请选择", preferredStyle: .actionSheet)
        let sync = UIAlertAction(title: "同步调用JS", style: .default) { _ in
            (self.webView as? DWKWebView)?.callHandler("callJSSync", arguments: ["同步", "这是来自Native的同步信息"]) { result in
                Log.d(result)
            }
        }

        let async = UIAlertAction(title: "异步调用JS", style: .default) { _ in
            (self.webView as? DWKWebView)?.callHandler("callJSAsync", arguments: ["异步", "这是来自Native的异步信息"]) { result in
                Log.d(result)
            }
        }

        let syncNameSpace = UIAlertAction(title: "同步调用JS(命名空间)", style: .default) { _ in
            // 可将下面 method1 改为 method2 以此调用 method2 方法
            (self.webView as? DWKWebView)?.callHandler("js.callJSSyncNameSpace.method1", arguments: ["同步", "这是来自Native的同步信息"]) { result in
                Log.d(result)
            }
        }

        let asyncNameSpace = UIAlertAction(title: "异步调用JS(命名空间)", style: .default) { _ in
            // 可将下面 method1 改为 method2 以此调用 method2 方法
            (self.webView as? DWKWebView)?.callHandler("js.callJSAsyncNameSpace.method1", arguments: ["异步", "这是来自Native的异步信息"]) { result in
                Log.d(result)
            }
        }

        let checkJSMethod = UIAlertAction(title: "判断是否有JS方法", style: .default) { _ in
            (self.webView as? DWKWebView)?.hasJavascriptMethod("callJSAsync") { result in
                Log.d(result)
            }
        }

        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        alertController.addAction(sync)
        alertController.addAction(async)
        alertController.addAction(syncNameSpace)
        alertController.addAction(asyncNameSpace)
         alertController.addAction(checkJSMethod)
        alertController.addAction(cancel)

        present(alertController, animated: true, completion: nil)

    }

    override func getWKWebView() -> WKWebView {
        let webview = DWKWebView()
        return webview
    }

    override func setUIDelegate() {
    }
}

extension JSAndNativeDSBrigeViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        initNavigation()
    }
}

//extension JSAndNativeDSBrigeViewController {
//    override func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//
//        Log.d(message)
//
//        completionHandler()
//    }
//}
