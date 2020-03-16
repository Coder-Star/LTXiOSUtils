//
//  BaseViewController.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/9/12.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
open class BaseViewController: UIViewController {

    /// 状态栏高度
    public private(set) var statusBarHeight: CGFloat?
    /// 导航栏高度
    public private(set) var navigationBarHeight: CGFloat?
    /// tabBar高度
    public private(set) var tabBarHeight: CGFloat?

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
        setupBarHeightData()
//        hideKeyboardWhenTappedAround()
    }

    open func setupBarHeightData() {
        statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        navigationBarHeight = navigationController?.navigationBar.frame.height
        tabBarHeight = tabBarController?.tabBar.frame.size.height
    }

}
