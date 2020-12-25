//
//  JSAndNativeFountionViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/7.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import WebKit
import LTXiOSUtils
import SwiftyJSON

class JSAndNativeFountionViewController: WkWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        setUserContentController()
        guard let htmlURL = Bundle.main.url(forResource: "JSAndNativeFountion", withExtension: "html") else {
            return
        }
        webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL)
    }

    private func initNavigation() {
        let rightBarItem = UIBarButtonItem(title: "调用JS", style: .plain, target: self, action: #selector(action))
        navigationItem.rightBarButtonItem = rightBarItem
    }

    @objc
    func action() {
        let info = "Hello，JS，我是Native"
        /// 注意下面这个函数参数，加上单引号
        /// evaluateJavaScript是一个异步方法
        webView.evaluateJavaScript("showJSInfo('\(info)')") { result, error in
            /// result是调用showJSInfo()这个js方法的返回值
            Log.d(result)
            Log.d(error)
        }
    }

    private func setUserContentController() {
        /// 注册方法到js，其中showInfoFromNative为方法名
        /// js使用 window.webkit.messageHandlers.showInfoFromNative.postMessage("发送信息到原生") 来调用原生
        /// 下列方法会引用循环引用问题，需要在合适的时机 removeScriptMessageHandler
        webView.configuration.userContentController.add(self, name: "showInfoFromNative")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "showInfoFromNative")
    }

    deinit {
        Log.d("JSAndNativeFountionViewController销毁")
    }
}

extension JSAndNativeFountionViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        Log.d(url)
        /// 拦截URL从而起到与原生通信的效果
        if url?.scheme == "app" {
            Log.d(url?.parametersFromQueryString?["info"])
            let info = url?.parametersFromQueryString?["info"] ?? ""
            HUD.showText(info)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// swift调用JS需要确保页面加载完毕
        initNavigation()
    }

    /// 页面即将白屏
    /// 当WKWebView占用内存较大时，WebContent Process 会 crash，从而出现白屏现象
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}

extension JSAndNativeFountionViewController {
   override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // 方法名
        Log.d(message.name)
        // 传递的数据
        Log.d(message.body)
        HUD.showText(JSON(message.body).description)
    }
}

extension JSAndNativeFountionViewController {
    // 通过输入框的形式来进行信息传递，可以同步获取数据
    override func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        // 输入框标题
        Log.d(prompt)
        // 默认输入信息
        Log.d(defaultText)
        completionHandler("输入框返回结果")
    }
}
