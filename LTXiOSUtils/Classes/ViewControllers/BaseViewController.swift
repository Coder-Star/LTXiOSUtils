//
//  LTXBaseViewController.swift
//  BaseIOSProject
//
//  Created by 李天星 on 2019/9/12.
//  Copyright © 2019年 李天星. All rights reserved.
//

import Foundation
class BaseViewController:UIViewController {

    var statusBarHeight:CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()

    }

    func setupData() {
        statusBarHeight = self.navigationController?.navigationBar.frame.height
    }

}
