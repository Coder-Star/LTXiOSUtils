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

    /// 导航栏标题
    public var titleInfo = ""
    /// 计算属性 子类用于重写
    open var currentTitleInfo: String {
        return ""
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setnNavigationItemTitle()
        setupBarHeightData()
    }

    open func setnNavigationItemTitle() {
        if let tempTitle = title, tempTitle.tx.isNotEmpty {

        } else if titleInfo.tx.isNotEmpty {
            self.navigationItem.title = titleInfo
        } else if currentTitleInfo.tx.isNotEmpty {
            self.navigationItem.title = currentTitleInfo
        }
    }

    open func setupBarHeightData() {
        statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        navigationBarHeight = navigationController?.navigationBar.frame.height
        tabBarHeight = tabBarController?.tabBar.frame.size.height
    }

    open override var prefersStatusBarHidden: Bool {
        return BaseViewController.statusBarHidden
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return BaseViewController.statusBarStyle
    }
}

extension BaseViewController {
    /// 状态栏是否隐藏
    public static var statusBarHidden: Bool = false
    /// 状态栏显示样式
    public static var statusBarStyle: UIStatusBarStyle = .lightContent
}
