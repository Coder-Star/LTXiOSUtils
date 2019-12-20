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
            BaseGroupTableMenuModel(code: "startAndEndDate", title: "起止时间(日期)"),
            BaseGroupTableMenuModel(code: "startAndEndTime", title: "起止时间(时间)")
        ]
        menu.append(fisrtMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "startAndEndDate":
            let start = Date()
            let end = Date().getDateByDays(days: 1)
            let popupView = DurationDatePickView.getPopupView(startDate: start, endDate: end, canGreatNow:true, dateType: .YMD)
            popupView.titleLabel.text = "请选择查询时间(日期)"
            popupView.sureBlock = { (start,end) in
               self.showAlert(message: "起始时间\(start)\n结束时间\(end)")
            }
            popupView.cancelBlock = {
                self.showAlert(message: "取消")
            }
            popupView.show()
        case "startAndEndTime":
            let start = Date()
            let end = Date().getDateByDays(days: 1)
            let popupView = DurationDatePickView.getPopupView(startDate: start, endDate: end, canGreatNow:true, dateType: .YMDHM)
//            popupView.titleLabel.text = "请选择查询时间(时间)"
            popupView.sureBlock = { (start,end) in
                self.showAlert(message: "起始时间\(start)\n结束时间\(end)")
            }
            popupView.cancelBlock = {
                self.showAlert(message: "取消")
            }
            popupView.show()
        default:
            HUD.showText("暂无此模块")
        }
    }
}
