//
//  BaseViewController.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/9/12.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
open class BaseViewController: UIViewController {

    /// 计算属性 子类用于重写，主要用于设置默认值
    open var currentTitleInfo: String {
        return ""
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setnNavigationItemTitle()
    }

    open func setnNavigationItemTitle() {
        if let tempTitle = title, tempTitle.tx.isNotEmpty {
            // 解决在Storyboard中设置ViewController的title后，navigationItem.title不赋值的问题
            if navigationItem.title?.isEmpty ?? true {
                navigationItem.title = tempTitle
            }
        } else if currentTitleInfo.tx.isNotEmpty {
            self.navigationItem.title = currentTitleInfo
        }
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
    public static var statusBarHidden = false
    /// 状态栏显示样式
    public static var statusBarStyle: UIStatusBarStyle = .lightContent
}
