//
//  CustomURLProtocol.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/12.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

class CustomURLProtocol: URLProtocol {

    // 判断请求是否进入自定义的NSURLProtocol加载器
    // 返回值表示是否对此次网络请求进行监控，并返回true时，需要实现协议的startLoading方法，否则会出现Crash
    override class func canInit(with request: URLRequest) -> Bool {
        Log.d(request)
        // 对于已处理过的请求则跳过，避免无限循环标签问题
        if URLProtocol.property(forKey: "WKURLProtocolHandledKey", in: request) != nil {
            Log.d("已处理")
            return false
        }

        return true
    }

    // 自定义请求的request，比如添加固定的header等
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    //判断两个请求是否为同一个请求，如果为同一个请求那么就会使用缓存数据
    //通常都是调用父类的该方法。我们也不许要特殊处理

    // FIXME: - 出现EXC_BAD_ACCESS
    //    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
    //        return requestIsCacheEquivalent(a, to: b)
    //    }

    // 开始请求
    override func startLoading() {
        guard let newRequest = (self.request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else { return }
        // NSURLProtocol接口的setProperty()方法可以给URL请求添加自定义属性。
        //（这样把处理过的请求做个标记，下一次就不再处理了，避免无限循环请求）

        URLProtocol.setProperty(true, forKey: "WKURLProtocolHandledKey",
                                in: newRequest)

        guard let url = request.url else { return }

        guard let htmlURL = Bundle.main.url(forResource: "CustomURLProtocolResponse", withExtension: "html") else { return }
        guard let data = try? Data(contentsOf: htmlURL) else { return }

        let mimeType = "text/html"
        let response = URLResponse(url: url, mimeType: mimeType, expectedContentLength: data.count, textEncodingName: "utf-8")

        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocol(self, didLoad: data)
        self.client?.urlProtocolDidFinishLoading(self)
    }

    // 结束请求
    override func stopLoading() {

    }

}
