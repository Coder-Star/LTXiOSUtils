//
//  HomeTabBarController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/2/12.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initChildViewControllers()
    }

    private func initChildViewControllers() {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem.title = "首页"
        homeViewController.tabBarItem.badgeValue = "10"
        homeViewController.tabBarItem.badgeColor = .black
        homeViewController.tabBarItem.image = R.image.home_tab()?.withRenderingMode(.alwaysOriginal)
        homeViewController.tabBarItem.selectedImage = R.image.home_tab_selected()?.withRenderingMode(.alwaysOriginal)

        let demoListViewControllerTitle = "Demo列表"
        let demoListViewController = DemoListViewController()
        demoListViewController.titleInfo = demoListViewControllerTitle //该值不仅影响顶部导航栏标题，还影响底部标题
        let demoListViewControllerWithNavigation = HomeNavigationController(rootViewController: demoListViewController)
        demoListViewControllerWithNavigation.tabBarItem.title = demoListViewControllerTitle
        demoListViewControllerWithNavigation.tabBarItem.core.addDot(color: .red)
        demoListViewControllerWithNavigation.tabBarItem.image = R.image.demoList_tab()?.withRenderingMode(.alwaysOriginal)
        demoListViewControllerWithNavigation.tabBarItem.selectedImage = R.image.demoList_tab_selected()?.withRenderingMode(.alwaysOriginal)

        let mineViewController = MineViewController()
        mineViewController.tabBarItem.title = "我"
        mineViewController.tabBarItem.image = R.image.mine_tab()?.withRenderingMode(.alwaysOriginal)
        mineViewController.tabBarItem.selectedImage = R.image.mine_tab_selected()?.withRenderingMode(.alwaysOriginal)
        DispatchQueue.main.delay(0.001) {
            mineViewController.tabBarItem.core.addDot()
        }

        self.viewControllers = [homeViewController,
                                demoListViewControllerWithNavigation,
                                mineViewController]
    }

}

extension HomeTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        QL1(viewController)
    }
}

class HomeNavigationController: UINavigationController {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
