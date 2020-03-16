//
//  GridMenuViewExampleViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/1/12.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils
import Kingfisher

class GridMenuViewExampleViewController: BaseUIViewController {
    private var menu = [
        GridMenuItem(code: "1", title: "第一菜单", image: R.image.menuItem(), markType: .none),
        GridMenuItem(code: "2", title: "第二菜单", image: R.image.menuItem(), markType: .point(isShow: true)),
        GridMenuItem(code: "3", title: "第三菜单", image: R.image.menuItem(), markType: .text(text: "角标")),
        GridMenuItem(code: "4", title: "第四菜单", image: R.image.menuItem(), markType: .number(number: 4)),
        GridMenuItem(code: "5", title: "第五菜单", image: R.image.menuItem(), markType: .number(number: 5)),
        GridMenuItem(code: "6", title: "第六菜单", image: R.image.menuItem(), markType: .number(number: 6)),
        GridMenuItem(code: "7", title: "第七菜单", image: R.image.menuItem(), markType: .number(number: 7)),
        GridMenuItem(code: "8", title: "第八菜单", image: R.image.menuItem(), markType: .number(number: 8)),
        GridMenuItem(code: "9", title: "第九菜单", image: R.image.menuItem(), markType: .number(number: 9)),
        GridMenuItem(code: "10", title: "第十菜单", image: R.image.menuItem(), markType: .number(number: 10)),
        GridMenuItem(code: "11", title: "十一菜单", image: R.image.menuItem(), markType: .number(number: 11)),
        GridMenuItem(code: "12", title: "十二菜单", image: R.image.menuItem(), markType: .number(number:12)),
        GridMenuItem(code: "13", title: "十三菜单", image: R.image.menuItem(), markType: .number(number: 13)),
        GridMenuItem(code: "14", title: "十四菜单", image: R.image.menuItem(), markType: .number(number: 14)),
        GridMenuItem(code: "15", title: "十五菜单", image: R.image.menuItem(), markType: .number(number: 15))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "格子式菜单"
        baseView.layoutIfNeeded()

        let pageStyle: PageControlStyle = .square(size: CGSize(width: 15, height: 5))
//        pageStyle = .ring(circleSize: 5)
//        pageStyle = .original(circleSize: 5)
//        pageStyle = .number(font: UIFont.systemFont(ofSize: 16), color: .black)

        let menuView = GridMenuView(width: baseView.width, row: 2, col: 4, menu: menu, pageStyle: pageStyle)
//        menuView.pageControlCurrentColor = .black
        menuView.delegate = self
        baseView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(menuView.heightInfo)
        }

        let scrollMenView = GridMenuView(width: baseView.width, row: 2, col: 4, menu: menu, mode: .horizontalScroll, pageStyle: pageStyle)
        scrollMenView.delegate = self
//        scrollMenView.pageControlCurrentColor = .black
        baseView.addSubview(scrollMenView)
        scrollMenView.snp.makeConstraints { make in
            make.top.equalTo(menuView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(scrollMenView.heightInfo)
        }

        let firstButtton = ViewFactory.getButton("第二个图标角标消失")
        let secondButton = ViewFactory.getButton("第三个图标改变文字")
        let thirdButton = ViewFactory.getButton("第四个图标改变数字")
        let forthButton = ViewFactory.getButton("第九个图标改变数字")
        baseView.add(firstButtton, secondButton, thirdButton, forthButton)
        firstButtton.snp.makeConstraints { make in
            make.top.equalTo(scrollMenView.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(4)
        }
        firstButtton.addTouchUpInsideAction {_ in
            menuView.updateMark(code: "2", isShow: false)
            scrollMenView.updateMark(code: "2", isShow: false)
        }
        secondButton.snp.makeConstraints { make in
            make.top.equalTo(firstButtton)
            make.left.equalTo(firstButtton.snp.right)
            make.width.equalToSuperview().dividedBy(4)
        }
        secondButton.addTouchUpInsideAction {_ in
            menuView.updateMark(code: "3", text: "变化")
            scrollMenView.updateMark(code: "3", text: "变化")
        }
        thirdButton.snp.makeConstraints { make in
            make.top.equalTo(firstButtton)
            make.left.equalTo(secondButton.snp.right)
            make.width.equalToSuperview().dividedBy(4)
        }
        thirdButton.addTouchUpInsideAction {_ in
            menuView.updateMark(code: "4", number: 10)
            scrollMenView.updateMark(code: "4", number: 10)
        }
        forthButton.snp.makeConstraints { make in
            make.top.equalTo(firstButtton)
            make.left.equalTo(thirdButton.snp.right)
            make.width.equalToSuperview().dividedBy(4)
        }
        forthButton.addTouchUpInsideAction {_ in
            menuView.updateMark(code: "9", number: 100)
            scrollMenView.updateMark(code: "9", number: 100)
        }

    }
}

extension GridMenuViewExampleViewController: GridMenuViewItemDelegate {
    func gridMenuView(_ gridMenuView: GridMenuView, selectedItemAt index: Int) {
        Log.d(index)
    }
}
