//
//  CustomURLSchemeHandler.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/12.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import WebKit

class CustomURLSchemeHandler: NSObject {

}

// 这种方式只可以在iOS11以上版本才可以使用，在以下版本需要借助URLProtocol进行拦截
@available(iOS 11.0, *)
extension CustomURLSchemeHandler: WKURLSchemeHandler {

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        Log.d(urlSchemeTask.request)
        guard let url = urlSchemeTask.request.url else { return }
        // 目前数据来源来自于本地，构造一个URLResponse和一个data
        // 如果数据来源于远程，可在网络请求回调后直接获取URLResponse与data
        guard let htmlURL = Bundle.main.url(forResource: "WKURLSchemeHandlerResponse", withExtension: "html") else { return }
        guard let data = try? Data(contentsOf: htmlURL) else { return }
        let mimeType = "text/html"
        let response = URLResponse(url: url, mimeType: mimeType, expectedContentLength: data.count, textEncodingName: "utf-8")

        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(data)
        urlSchemeTask.didFinish()
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        Log.d(urlSchemeTask.request)
    }
}
