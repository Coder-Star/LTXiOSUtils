//
//  PickViewDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/12/19.
//  Copyright © 2019 李天星. All rights reserved.
//

import Foundation

class PickViewDemoViewController: BaseGroupTableMenuViewController {

    /// 单列
//    private let singleData = [String]()

    private let singleData = ["swift", "ObjecTive-C", "C", "C++", "java", "php", "python", "ruby", "js"]

    /// 多列不关联
    private let multipleData = [
        ["1天", "2天", "3天", "4天", "5天", "6天", "7天"],
        ["1小时", "2小时", "3小时", "4小时", "5小时"],
        ["1分钟","2分钟","3分钟","4分钟","5分钟","6分钟","7分钟","8分钟","9分钟","10分钟"]
    ]

    /// 多列关联
    private let multipleAssociatedData: [[[String: [String]?]]] = [
        [   ["交通工具": ["陆地", "空中", "水上"]],//字典
            ["食品": ["健康食品", "垃圾食品"]],
            ["游戏": ["益智游戏", "角色游戏"]]
        ],
        [   ["陆地": ["公交车", "小轿车", "自行车"]],
            ["空中": ["飞机"]],
            ["水上": ["轮船"]],
            ["健康食品": ["蔬菜", "水果"]],
            ["垃圾食品": ["辣条", "不健康小吃"]],
            ["益智游戏": ["消消乐", "消灭星星"]],
            ["角色游戏": ["lol", "cf"]]
        ]
    ]

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

        let secondMenu = [
            BaseGroupTableMenuModel(code: "date", title: "日期"),
            BaseGroupTableMenuModel(code: "time", title: "时间"),
            BaseGroupTableMenuModel(code: "dateAndTime", title: "时间和日期")
        ]
        menu.append(secondMenu)

        let thirdMenu = [
            BaseGroupTableMenuModel(code: "single", title: "单列"),
            BaseGroupTableMenuModel(code: "multiple", title: "多列不关联"),
            BaseGroupTableMenuModel(code: "multipleAssociated", title: "多列关联")
        ]
        menu.append(thirdMenu)

        let fourthMenu = [
            BaseGroupTableMenuModel(code: "city", title: "省市区")
        ]
        menu.append(fourthMenu)

        let fifthMenu = [
            BaseGroupTableMenuModel(code: "multipleSelect", title: "多选")
        ]
        menu.append(fifthMenu)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = .none
        return cell
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
            popupView.titleLabel.text = "请选择查询时间(时间)"
            popupView.sureBlock = { (start,end) in
                self.showAlert(message: "起始时间\(start)\n结束时间\(end)")
            }
            popupView.cancelBlock = {
                self.showAlert(message: "取消")
            }
            popupView.show()
        case "date":
            PickerViewManager.showDatePicker("日期选择") { selectedDate in
                self.showAlert(message: selectedDate.formatDate(format: .YMD))
            }
        case "time":
            var dateStyle = DatePickerSetting()
            dateStyle.dateMode = .time
            PickerViewManager.showDatePicker("时间选择",datePickerSetting: dateStyle) { selectedDate in
                self.showAlert(message: selectedDate.formatDate(format: .HMS))
            }
        case "dateAndTime":
            var dateStyle = DatePickerSetting()
            dateStyle.dateMode = .dateAndTime
            PickerViewManager.showDatePicker("日期与时间选择",datePickerSetting: dateStyle) { selectedDate in
                self.showAlert(message: selectedDate.formatDate(format: .YMDHMS))
            }
        case "single":
            PickerViewManager.showSingleColPicker("单列", data: singleData, defaultSelectedIndex: 2) { (selectedIndex, selectedValue) in
                self.showAlert(message:"\(selectedIndex)\(selectedValue)")
            }
        case "multiple":
            PickerViewManager.showMultipleColsPicker("多列不关联", data: multipleData, defaultSelectedIndexs: [0,1,1]) { (selectedIndexs, selectedValues) in
                self.showAlert(message:"\(selectedIndexs)\(selectedValues)")
            }
        case "multipleAssociated":
            PickerViewManager.showMultipleAssociatedColsPicker("多列关联", data: multipleAssociatedData, defaultSelectedValues: ["食品","垃圾食品","不健康小吃"]) { (selectedIndexs, selectedValues) in
                self.showAlert(message:"\(selectedIndexs)\(selectedValues)")
            }
        case "city":
            PickerViewManager.showCitiesPicker("省市区选择", defaultSelectedValues: ["天津市"]) { (selectedIndexs, selectedValues) in
                self.showAlert(message:"\(selectedIndexs)   \(selectedValues)")
            }
        case "multipleSelect":
            MultiSelectPickView.showView(title: "选择", data: singleData, defaultSelectedIndexs: [1]) { index,value in
                self.showAlert(message:"\(index)   \(value)")
            }
        default:
            HUD.showText("暂无此模块")
        }
    }
}
