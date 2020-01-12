//
//  GridMenuViewExampleViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/1/12.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils

class GridMenuViewExampleViewController: BaseUIViewController {

    private var menu = [
        GridMenuItem(code: "1", title: "第一菜单",image: R.image.menuItem(), markType: .none),
        GridMenuItem(code: "2", title: "第二菜单",image: R.image.menuItem(), markType: .point(isShow: true)),
        GridMenuItem(code: "3", title: "第三菜单",image: R.image.menuItem(), markType: .text(text: "角标")),
        GridMenuItem(code: "4", title: "第四菜单",image: R.image.menuItem(), markType: .number(number: 4)),
        GridMenuItem(code: "5", title: "第五菜单",image: R.image.menuItem(), markType: .number(number: 5)),
        GridMenuItem(code: "6", title: "第六菜单",image: R.image.menuItem(), markType: .number(number: 6)),
        GridMenuItem(code: "7", title: "第七菜单",image: R.image.menuItem(), markType: .number(number: 7)),
        GridMenuItem(code: "8", title: "第八菜单",image: R.image.menuItem(), markType: .number(number: 8)),
        GridMenuItem(code: "9", title: "第九菜单",image: R.image.menuItem(), markType: .number(number: 9))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        let menuView = GridMenuView(width: baseView.width, row: 2, col: 4, menu: menu)
        baseView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
}
