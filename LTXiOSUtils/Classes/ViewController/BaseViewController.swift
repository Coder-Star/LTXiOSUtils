//
//  LTXBaseViewController.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/9/12.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
open class BaseViewController: UIViewController {

    /// 状态栏高度
    public private(set) var statusBarHeight: CGFloat?
    /// 标题
    public var titleInfo = ""

    /// 计算属性 子类用于重写
    open var currentTitleInfo: String {
        return titleInfo
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        if let tempTitle = title, tempTitle.isNotEmpty {

        } else if currentTitleInfo.isNotEmpty {
            title = currentTitleInfo
        }
        setupData()
        hideKeyboardWhenTappedAround()
    }

    open func setupData() {
        statusBarHeight = self.navigationController?.navigationBar.frame.height
    }

}
