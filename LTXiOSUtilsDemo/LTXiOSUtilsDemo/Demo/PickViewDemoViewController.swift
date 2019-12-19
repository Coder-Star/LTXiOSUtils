//
//  PickViewDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/12/19.
//  Copyright © 2019 李天星. All rights reserved.
//

import Foundation

class PickViewDemoViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择器"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "startAndEnd", title: "起止时间")
        ]
        menu.append(fisrtMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "startAndEnd":
            let start = Date()
            let end = Date().getDateByDays(days: 1)
            let popupView = DurationDatePickView.getPopupView(delegate: self as DurationDatePickViewDelegate,startDate: start, endDate: end, isDateCanGreatNow:true, dateType: .YMDHM)
            popupView.titleLabel.text = "请选择查询时间"
            popupView.show()
        default:
            HUD.showText("暂无此模块")
        }
    }
}

extension PickViewDemoViewController: DurationDatePickViewDelegate {
    func sure(startDate: String, endDate: String) {
        QL1(startDate)
        QL1(endDate)
    }
}
