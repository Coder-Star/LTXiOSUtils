//
//  JSAndNativeViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/7.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils
import WebKit

/**
 WkWebView是再在独立于APP进程的另外进程运行
 WKWebView 发起的请求不会自动带上存储于 NSHTTPCookieStorage 容器中的 Cookie
 */

class WkWebViewController: BaseUIViewController {

    lazy var webView: WKWebView = {
        return getWKWebView()
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        return progressView
    }()

    private let estimatedProgressKeyPath = "estimatedProgress"
    private let titleKeyPath = "title"
    private let loadingKeyPath = "loading"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebview()
        setupProgressView()
        setUIDelegate()

        setLogHandler()

        /// 清除所有缓存
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0)) {}

        // 关闭回弹效果
        webView.scrollView.bounces = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "logHandler")
    }

    func getWKWebView() -> WKWebView {
        let webview = WKWebView(frame: .zero, configuration: getConfiguration())
        return webview
    }

    func getConfiguration() -> WKWebViewConfiguration {
        let preferences = WKPreferences()
        // 禁用JS
        // preferences.javaScriptEnabled = false
        // 设置最小字体
        preferences.minimumFontSize = 20

        let config = WKWebViewConfiguration()
        config.preferences = preferences
        return config
    }

    func setUIDelegate() {
        webView.uiDelegate = self
    }

    func setLogHandler() {
        let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        // 执行自定义js
        webView.configuration.userContentController.addUserScript(script)
        // 定义方法供原生调用
        webView.configuration.userContentController.add(self, name: "logHandler")
    }

    deinit {
        webView.removeObserver(self, forKeyPath: estimatedProgressKeyPath)
        webView.removeObserver(self, forKeyPath: titleKeyPath)
        webView.removeObserver(self, forKeyPath: loadingKeyPath)
    }
}

extension WkWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
            Log.d("LOG: \(message.body)")
        }
    }
}

extension WkWebViewController {

    private func setupWebview() {
        self.baseView.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupProgressView() {
        progressView.tintColor = .red
        progressView.trackTintColor = .white
        baseView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(1)
            make.height.equalTo(1)
        }
        webView.addObserver(self, forKeyPath: estimatedProgressKeyPath, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: titleKeyPath, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: loadingKeyPath, options: .new, context: nil)
    }

    // swiftlint:disable block_based_kvo
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case estimatedProgressKeyPath?:
            let estimatedProgress = Float(webView.estimatedProgress)
            Log.d(estimatedProgress)
            progressView.alpha = 1
            progressView.setProgress(estimatedProgress, animated: true)
        case titleKeyPath:
            title = webView.title
        case loadingKeyPath:
            Log.d("是否加载完毕:\(!webView.isLoading)")
            // 当访问一个不存在的url时，estimatedProgress不会到1，需要通过isLoading参数判断是否隐藏进度条
            if !webView.isLoading {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { _ in
                    self.progressView.setProgress(0, animated: false)
                })
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension WkWebViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        if self.navigationController?.visibleViewController != self {
            completionHandler()
            return
        }
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAciton = UIAlertAction(title: "确定", style: .default) { _ in
            completionHandler()
        }
        alertController.addAction(okAciton)
        if presentedViewController == nil {
            present(alertController, animated: true, completion: nil)
        } else {
            completionHandler()
        }
    }

    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        if self.navigationController?.visibleViewController != self {
            completionHandler(false)
            return
        }
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAciton = UIAlertAction(title: "确定", style: .default) { _ in
            completionHandler(true)
        }
        let cancelAciton = UIAlertAction(title: "取消", style: .cancel) { _ in
            completionHandler(false)
        }
        alertController.addAction(okAciton)
        alertController.addAction(cancelAciton)
        if presentedViewController == nil {
            present(alertController, animated: true, completion: nil)
        } else {
            completionHandler(false)
        }
    }

    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        if self.navigationController?.visibleViewController != self {
            completionHandler("")
            return
        }
        let alertController = UIAlertController(title: prompt, message: "", preferredStyle: .alert)
        alertController.addTextField {(textField: UITextField!) -> Void in
            textField.clearButtonMode = .whileEditing
            textField.text = defaultText
        }
        let okAciton = UIAlertAction(title: "完成", style: .default) { _ in
            if alertController.textFields != nil, alertController.textFields!.count > 0 {
                completionHandler(alertController.textFields![0].text)
            } else {
                completionHandler("")
            }
        }
        alertController.addAction(okAciton)
        if presentedViewController == nil {
            present(alertController, animated: true, completion: nil)
        } else {
            completionHandler("")
        }
    }
}
