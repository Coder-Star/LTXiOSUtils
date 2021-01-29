//
//  InterceptWkWebViewURLViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/12.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import WebKit

public enum InterceptWkWebViewURLViewControllerType: String {
    case customURLProtocol = "CustomURLProtocol"
    case wkURLSchemeHandler = "WKURLSchemeHandler"
}

class InterceptWkWebViewURLViewController: WkWebViewController {

    var type: InterceptWkWebViewURLViewControllerType?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self

        guard let htmlURL = Bundle.main.url(forResource: type?.rawValue, withExtension: "html") else {
            return
        }
        webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL)

        if type == .customURLProtocol {
            // 将APP中网络请求交给CustomURLProtocol监控
            // FIXME: - 注册之后目前无法拦截Ajax请求，并且DSBrige库失效
            URLProtocol.registerClass(CustomURLProtocol.self)
            webView.supportURLProtocol()
        }
    }

    override func getConfiguration() -> WKWebViewConfiguration {
        let config = super.getConfiguration()
        // 利用KVO设置允许跨域
        config.setValue(true, forKey: "_allowUniversalAccessFromFileURLs")
        if #available(iOS 11.0, *) {
            // 必须在创建WKWebView的时候设置，创建完成再设置无效果，自定义的scheme不能包括常用的，如https、http、about、data、blob、ftp
            config.setURLSchemeHandler(CustomURLSchemeHandler(), forURLScheme: "coderstar")
        }
        return config
    }
}

extension InterceptWkWebViewURLViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let urlStr = navigationAction.request.url?.absoluteString else {
            decisionHandler(.cancel)
            return
        }
        Log.d(urlStr)
        // 因为该方法是在请求之前回调，该url在还未发出请求之前就被修改了scheme，不是http及https，所以不会被CustomURLProtocol拦截
        if urlStr == "http://schemehandler/" {
            webView.load(URLRequest(url: URL(string: urlStr.replacingOccurrences(of: "http", with: "coderstar"))!))
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}

extension WKWebView {

    // WkWebView与APP不在同一个进程，需要手动将WKWebview的http、https交给URLProtocol处理
    // 下面使用私有API的方式容易不通过苹果的审核，可以将私有API使用字符串拼接的方式
    func supportURLProtocol() {
        let selector = Selector(("registerSchemeForCustomProtocol:"))
        let vc = WKWebView().value(forKey: "browsingContextController") as AnyObject
        let cls = type(of: vc) as AnyObject

        // 拦截下列两个协议的请求
        _ = cls.perform(selector, with: "http")
        _ = cls.perform(selector, with: "https")
    }
}
