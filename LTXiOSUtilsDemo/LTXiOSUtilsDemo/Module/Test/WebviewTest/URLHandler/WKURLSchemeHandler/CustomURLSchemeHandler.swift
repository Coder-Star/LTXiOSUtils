//
//  CustomURLSchemeHandler.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/12.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import WebKit
import LTXiOSUtils
import Alamofire

class CustomURLSchemeHandler: NSObject {

}

/**
 WKURLSchemeHandler 在 iOS 11.3 之前 (不包含) 也会丢失 Body，
 在 iOS 11.3 以后 WebKit 做了优化只会丢失 Blob 类型数据
 */

// 这种方式只可以在iOS11以上版本才可以使用，在以下版本需要借助URLProtocol进行拦截
// 这种方式比较适合用来加载图片，可以和原生部分共享缓存形式
@available(iOS 11.0, *)
extension CustomURLSchemeHandler: WKURLSchemeHandler {

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        Log.d(urlSchemeTask.request)
        guard let url = urlSchemeTask.request.url else { return }

        if url.absoluteString == "coderstar://schemehandler/" {
            // 目前数据来源来自于本地，构造一个URLResponse和一个data
            // 如果数据来源于远程，可在网络请求回调后直接获取URLResponse与data
            guard let htmlURL = Bundle.main.url(forResource: "WKURLSchemeHandlerResponse", withExtension: "html") else { return }
            guard let data = try? Data(contentsOf: htmlURL) else { return }
            let mimeType = "text/html"
            let response = URLResponse(url: url, mimeType: mimeType, expectedContentLength: data.count, textEncodingName: "utf-8")

            // 两个didReceive都必须回调
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
        } else if  url.absoluteString == "coderstar://www.fastmock.site/mock/5abd18409d0a2270b34088a07457e68f/LTXMock/pagerViewConfigInfo" {
            AF.request(url.absoluteString.replacingOccurrences(of: "coderstar", with: "https"), method: .get).validate().responseJSON { reponse in
                Log.d(reponse.response?.mimeType) // application/json
                Log.d(reponse.response?.textEncodingName) // utf-8
                urlSchemeTask.didReceive(reponse.response!)
                urlSchemeTask.didReceive(reponse.data!)
                urlSchemeTask.didFinish()
            }
        }
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        Log.d(urlSchemeTask.request)
    }
}
