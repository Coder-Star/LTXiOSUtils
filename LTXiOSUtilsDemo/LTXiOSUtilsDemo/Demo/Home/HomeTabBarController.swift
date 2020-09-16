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

    private var homeViewController: HomeViewController = {
        let viewController = HomeViewController()
        return viewController
    }()

    private var demoListViewController: DemoListViewController = {
        let viewController = DemoListViewController()
        return viewController
    }()

    private var mineViewController: UINavigationController = {
        let viewController = HomeNavigationController(rootViewController: MineViewController())
        return viewController
    }()

//    private var mineViewController: UIViewController = {
//        let viewController = MineViewController()
//        return viewController
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.delegate = self
        initChildViewControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // TabBarItem加载到TabBar上是在 viewDidLoad 之后执行的
        mineViewController.tabBarItem.tx.addDot()
    }

    private func initChildViewControllers() {
        let homeViewControllerTitle = "首页"
        homeViewController.titleInfo = homeViewControllerTitle
        let homeViewControllerWithNavigation = HomeNavigationController(rootViewController: homeViewController)
        homeViewControllerWithNavigation.tabBarItem.title = homeViewControllerTitle
        homeViewControllerWithNavigation.tabBarItem.badgeValue = "10"
        homeViewControllerWithNavigation.tabBarItem.badgeColor = .black
        homeViewControllerWithNavigation.tabBarItem.image = R.image.home_tab()?.withRenderingMode(.alwaysOriginal)
        homeViewControllerWithNavigation.tabBarItem.selectedImage = R.image.home_tab_selected()?.withRenderingMode(.alwaysOriginal)

        let demoListViewControllerTitle = "Demo列表".localized()
        demoListViewController.titleInfo = demoListViewControllerTitle
        let demoListViewControllerWithNavigation = HomeNavigationController(rootViewController: demoListViewController)
        demoListViewControllerWithNavigation.tabBarItem.title = demoListViewControllerTitle
        demoListViewControllerWithNavigation.tabBarItem.tx.addDot(color: .red)
        demoListViewControllerWithNavigation.tabBarItem.image = R.image.demoList_tab()?.withRenderingMode(.alwaysOriginal)
        demoListViewControllerWithNavigation.tabBarItem.selectedImage = R.image.demoList_tab_selected()?.withRenderingMode(.alwaysOriginal)

        mineViewController.tabBarItem.title = "我"
        mineViewController.tabBarItem.image = R.image.mine_tab()?.withRenderingMode(.alwaysOriginal)
        mineViewController.tabBarItem.selectedImage = R.image.mine_tab_selected()?.withRenderingMode(.alwaysOriginal)

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
