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

class JSAndNativeDSBrigeViewController: JSAndNativeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self

        (webView as? DWKWebView)?.dsuiDelegate = self
        (webView as? DWKWebView)?.setDebugMode(true)

        ///
//        (webView as? DWKWebView)?.disableJavascriptDialogBlock(false)

        // 当js使用window.close()，会触发该监听器
        (webView as? DWKWebView)?.setJavascriptCloseWindowListener {
            HUD.showText("JS执行了window.close()")
        }

        setJavascriptObject()
        guard let htmlURL = Bundle.main.url(forResource: "JSAndNativeDSBrige", withExtension: "html") else {
            return
        }
        webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL)
    }

    private func initNavigation() {
        let rightBarItemOne = UIBarButtonItem(title: "同步调用JS", style: .plain, target: self, action: #selector(actionSync))
        let rightBarItemTwo = UIBarButtonItem(title: "异步调用JS", style: .plain, target: self, action: #selector(actionAsync))
        navigationItem.rightBarButtonItems = [rightBarItemOne, rightBarItemTwo]
    }

    private func setJavascriptObject() {
        (webView as? DWKWebView)?.addJavascriptObject(NativeAPIForJS.shared, namespace: NativeAPIForJS.nameSpace)
    }

    @objc
    func actionSync() {
//        (webView as? DWKWebView)?.callHandler(<#T##methodName: String##String#>, arguments: <#T##[Any]?#>)
    }

    @objc
    func actionAsync() {

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
