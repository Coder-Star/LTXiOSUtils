//
//  HomeNavigationController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/2/13.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

class HomeNavigationController: UINavigationController {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
