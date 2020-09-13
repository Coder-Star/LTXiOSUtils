//
//  JSAndNativeJSBrigeViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/7.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import WebKit
import LTXiOSUtils
import SwiftyJSON
import WebViewJavascriptBridge

/**
 WebViewJavascriptBridge基本原理
 JS -> Native 通过decidePolicyFor拦截url获取信息
 Native -> JS evaluateJavaScript

 因为WebViewJavascriptBridge需要借助decidePolicyFor通信，所以需要WebViewJavascriptBridge内部实现 WKNavigationDelegate 协议，不可将协议交给其他类进行实现，如果想实现 WKNavigationDelegate 协议，可以通过setWebViewDelegate方法将自身作为协议的实现
 */

class JSAndNativeJSBrigeViewController: WkWebViewController {

    var webBridge: WKWebViewJavascriptBridge?

    override func viewDidLoad() {
        super.viewDidLoad()
        webBridge = WKWebViewJavascriptBridge.init(for: webView)

        webBridge?.setWebViewDelegate(self)

        iniNativeCall()
        guard let htmlURL = Bundle.main.url(forResource: "JSAndNativeJSBrige", withExtension: "html") else {
            return
        }
        /// 第一个参数为页面路径，第二个参数为页面加载过程中可能会访问的路径，比如Css、Js、Image路径地址
        webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL)
    }

    private func initNavigation() {
        let rightBarItem = UIBarButtonItem(title: "调用JS", style: .plain, target: self, action: #selector(action))
        navigationItem.rightBarButtonItem = rightBarItem
    }

    private func iniNativeCall() {
        self.webBridge?.registerHandler("callForJS") { (param, callBack) in
            Log.d(param)
            Log.d(callBack)
            guard let callBack = callBack else {
                return
            }
            callBack("收到来自JS的字典参数，这是Native的回复")
        }
    }

    @objc
    func action() {
        let param = ["message": "来自Native的参数"]
        webBridge?.callHandler("callForNative", data: param) { result in
            Log.d(result)
        }
    }

}

extension JSAndNativeJSBrigeViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        initNavigation()
    }
}
