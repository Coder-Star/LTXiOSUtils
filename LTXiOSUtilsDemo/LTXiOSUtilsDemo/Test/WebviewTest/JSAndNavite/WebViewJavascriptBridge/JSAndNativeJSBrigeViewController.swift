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

class JSAndNativeJSBrigeViewController: WkWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
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

    @objc
    func action() {
    }

}

extension JSAndNativeJSBrigeViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        initNavigation()
    }
}
