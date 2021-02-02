//
//  DemoListViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import UIKit
import LTXiOSUtils

class DemoListViewController: BaseGroupTableMenuViewController {

    let titles = ["创建群聊", "加好友/群", "扫一扫", "面对面快传", "付款", "拍摄"]
    let images = [UIImage(named: "right_menu_multichat_white"),
                   UIImage(named: "right_menu_addFri_white"),
                   UIImage(named: "right_menu_QR_white"),
                   UIImage(named: "right_menu_facetoface_white"),
                   UIImage(named: "right_menu_payMoney_white"),
                   UIImage(named: "right_menu_sendvideo_white")]
    lazy var menuView: FWMenuView = {
        let vProperty = FWMenuViewProperty()
        vProperty.popupCustomAlignment = .topRight
        vProperty.popupAnimationType = .scale
        vProperty.maskViewColor = .clear
        vProperty.popupViewEdgeInsets = UIEdgeInsets(top: DeviceInfo.statusBarHeight + self.tx.navigationBarHeight!, left: 0, bottom: 0, right: 6)
        vProperty.topBottomMargin = 0
        vProperty.animationDuration = 0.3
        vProperty.popupArrowStyle = .round
        vProperty.popupArrowVertexScaleX = 0.95
        vProperty.backgroundColor = UIColor(hexString: "#403F42")
        vProperty.splitColor = UIColor(hexString: "#403F42")
        vProperty.separatorColor = UIColor(hexString: "#5B5B5D")
        vProperty.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                         NSAttributedString.Key.backgroundColor: UIColor.clear,
                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
        vProperty.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

        let menuView = FWMenuView.menu(itemTitles: titles, itemImageNames: images as? [UIImage], property: vProperty) { _, index, _ in
            Log.d("Menu：点击了第\(index)个按钮")
        }
        return menuView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let addBarButton = UIBarButtonItem(image: R.image.add(), style: .plain, target: self, action: #selector(self.add))
        self.navigationItem.rightBarButtonItem = addBarButton
    }

    @objc private func add() {
        menuView.show()
    }

    override func setMenu() {
        let componetMenu = [
            BaseGroupTableMenuModel(code: "HUD", title: "HUD加载框"),
            BaseGroupTableMenuModel(code: "Pick", title: "选择器"),
            BaseGroupTableMenuModel(code: "Component", title: "控件集锦"),
            BaseGroupTableMenuModel(code: "Menu", title: "菜单"),
            BaseGroupTableMenuModel(code: "TreeView", title: "无限级树形View"),
            BaseGroupTableMenuModel(code: "FoldView", title: "二级折叠View"),
            BaseGroupTableMenuModel(code: "AlertView", title: "弹出框"),
            BaseGroupTableMenuModel(code: "MaskPopup", title: "蒙板弹出"),
            BaseGroupTableMenuModel(code: "PickImage", title: "图片选择"),
            BaseGroupTableMenuModel(code: "ShowImage", title: "图片加载")
        ]
        menu.append(componetMenu)

        let networkMenu = [
            BaseGroupTableMenuModel(code: "Network", title: "网络请求相关")
        ]
        menu.append(networkMenu)

        let extensionMenu = [
            BaseGroupTableMenuModel(code: "Extension", title: "扩展")
        ]
        menu.append(extensionMenu)

        let mediatorAndRouterMenu = [
            BaseGroupTableMenuModel(code: "MediatorAndRouter", title: "组件通信")
        ]
        menu.append(mediatorAndRouterMenu)

        let testCrashMenu = [
            BaseGroupTableMenuModel(code: "OCCrash", title: "OC Crash触发"),
            BaseGroupTableMenuModel(code: "SwiftCrash", title: "Swift Crash触发")
        ]
        menu.append(testCrashMenu)

    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "HUD":
            navigationController?.pushViewController(HUDDemoViewController(), animated: true)
        case "Network":
            navigationController?.pushViewController(NetworkDemoViewController(), animated: true)
        case "Pick":
            navigationController?.pushViewController(PickViewDemoViewController(), animated: true)
        case "Component":
            navigationController?.pushViewController(ComponentCollectionsViewController(), animated: true)
        case "Extension":
            navigationController?.pushViewController(ExtensionExampleMenuViewController(), animated: true)
        case "Menu":
            navigationController?.pushViewController(GridMenuViewExampleViewController(), animated: true)
        case "FoldView":
            navigationController?.pushViewController(FoldViewDemoViewController(), animated: true)
        case "TreeView":
            navigationController?.pushViewController(TreeViewDemoViewController(), animated: true)
        case "AlertView":
            let viewController = BaseNavigationController(rootViewController: FWDemoViewController())
            present(viewController, animated: true, completion: nil)
        case "MaskPopup":
            navigationController?.pushViewController(MaskPopupViewController(), animated: true)
        case "PickImage":
            navigationController?.pushViewController(PickImageDemoViewController(), animated: true)
        case "MediatorAndRouter":
            navigationController?.pushViewController(MediatorAndRouterDemoViewController(), animated: true)
        case "OCCrash":
            TestOCError.testArrayIndexOutOfExpection()
        case "SwiftCrash":
            let a = [1]
            Log.d(a[10])
        case "ShowImage":
            navigationController?.pushViewController(ShowImageViewController(), animated: true)
        default:
            HUD.showText("暂无此模块")
        }
    }
}
