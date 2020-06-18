//
//  HomeTabBarController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/2/12.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import Localize_Swift

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.delegate = self
        initChildViewControllers()

        Log.d(NetworkConstant.OaUrl)
    }

    private func initChildViewControllers() {
        let homeViewController = HomeViewController()
        let homeViewControllerTitle = "首页"
        homeViewController.titleInfo = homeViewControllerTitle
        let homeViewControllerWithNavigation = HomeNavigationController(rootViewController: homeViewController)
        homeViewControllerWithNavigation.tabBarItem.title = homeViewControllerTitle
        homeViewControllerWithNavigation.tabBarItem.badgeValue = "10"
        homeViewControllerWithNavigation.tabBarItem.badgeColor = .black
        homeViewControllerWithNavigation.tabBarItem.image = R.image.home_tab()?.withRenderingMode(.alwaysOriginal)
        homeViewControllerWithNavigation.tabBarItem.selectedImage = R.image.home_tab_selected()?.withRenderingMode(.alwaysOriginal)

        let demoListViewControllerTitle = "Demo列表".localized()
        let demoListViewController = DemoListViewController()
        demoListViewController.titleInfo = demoListViewControllerTitle
        let demoListViewControllerWithNavigation = HomeNavigationController(rootViewController: demoListViewController)
        demoListViewControllerWithNavigation.tabBarItem.title = demoListViewControllerTitle
        demoListViewControllerWithNavigation.tabBarItem.tx.addDot(color: .red)
        demoListViewControllerWithNavigation.tabBarItem.image = R.image.demoList_tab()?.withRenderingMode(.alwaysOriginal)
        demoListViewControllerWithNavigation.tabBarItem.selectedImage = R.image.demoList_tab_selected()?.withRenderingMode(.alwaysOriginal)

        let mineViewController = MineViewController()
        mineViewController.tabBarItem.title = "我"
        mineViewController.tabBarItem.image = R.image.mine_tab()?.withRenderingMode(.alwaysOriginal)
        mineViewController.tabBarItem.selectedImage = R.image.mine_tab_selected()?.withRenderingMode(.alwaysOriginal)
        DispatchQueue.main.tx.delay(0.001) {
            mineViewController.tabBarItem.tx.addDot()
        }

        self.viewControllers = [homeViewControllerWithNavigation,
                                demoListViewControllerWithNavigation,
                                mineViewController]
    }

}

extension HomeTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UIFeedbackGeneratorUtils.impactFeedback(style: .light)
        Log.d(viewController)
    }
}
