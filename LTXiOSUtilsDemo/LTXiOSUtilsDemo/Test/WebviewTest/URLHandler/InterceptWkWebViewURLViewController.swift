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
            URLProtocol.registerClass(CustomURLProtocol.self)
            //
            webView.supportURLProtocol()
        }
    }

    override func getConfiguration() -> WKWebViewConfiguration {
        let config = super.getConfiguration()
        if #available(iOS 11.0, *) {
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
        // 因为该方法是在请求之前回调，该url在还未发出请求之前就被修改了scheme，所以通过CustomURLProtocol拦截不到
        if urlStr == "http://schemehandler/" {
            webView.load(URLRequest(url: URL(string: urlStr.replacingOccurrences(of: "http", with: "coderstar"))!))
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}

extension WKWebView {
    func supportURLProtocol() {
        let selector = Selector(("registerSchemeForCustomProtocol:"))
        let vc = WKWebView().value(forKey: "browsingContextController") as AnyObject
        let cls = type(of: vc) as AnyObject
        Log.d(vc)
        Log.d(cls)
        _ = cls.perform(selector, with: "http")
        _ = cls.perform(selector, with: "https")
    }
}
