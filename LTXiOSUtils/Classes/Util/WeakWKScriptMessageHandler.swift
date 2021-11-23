//
//  WeakWKScriptMessageHandler.swift
//  LTXiOSUtils
//  解决WKUserContentController add方法 循环引用问题
//  Created by CoderStar on 2021/11/23.
//

import WebKit

/**
 使用例子（两者皆可）：
     1、WKUserContentController().weakAdd(self, name: "")
     2、WKUserContentController().add(WeakWKScriptMessageHandler(self), name: "")
 */

final public class WeakWKScriptMessageHandler: NSObject {
    private weak var weakScriptMessageHandler: WKScriptMessageHandler?

    public init(_ weakScriptMessageHandler: WKScriptMessageHandler) {
        super.init()
        self.weakScriptMessageHandler = weakScriptMessageHandler
    }
}

extension WeakWKScriptMessageHandler: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        weakScriptMessageHandler?.userContentController(userContentController, didReceive: message)
    }
}

extension WKUserContentController {
    open func weakAdd(_ scriptMessageHandler: WKScriptMessageHandler, name: String) {
        add(WeakWKScriptMessageHandler(scriptMessageHandler), name: name)
    }
}
