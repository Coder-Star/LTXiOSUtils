//
//  FWDemoViewController.swift
//  FWPopupView
//
//  Created by xfg on 2018/3/26.
//  Copyright © 2018年 xfg. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

class FWDemoViewController: UITableViewController {

    /// 注意：这边不同的示例可能还附加演示了一些特性（比如：遮罩层是否能够点击、遮罩层的背景颜色等等），有用到时可以参考
    var titleArray = ["0、Alert - 单个按钮",
                      "1、Alert - 两个按钮",
                      "2、Alert - 两个按钮（修改参数）",
                      "3、Alert - 多个按钮",
                      "4、Alert - 带输入框",
                      "5、Alert - 带自定义视图",
                      "6、Sheet - 少量Item",
                      "7、Sheet - 标题+少量Item",
                      "8、Sheet - 大量Item",
                      "9、Menu - 自定义菜单",
                      "10、Custom - 自定义弹窗",
                      "11、CustomSheet - 类似Sheet效果",
                      "12、CustomSheet - 类似Sheet效果2", "13、同时显示两个弹窗（展示可以同时调用多个弹窗的显示方法，但是显示过程按“后来者先显示”的原则，因此过程则反之）",
                      "14、RadioButton",
                      "15、含RadioButton的Alert"]

    let block: FWPopupItemClickedBlock = { (popupView, index, title) in
        print("AlertView：点击了第\(index)个按钮")
    }

    lazy var customSheetView: FWCustomSheetView = {
        let property = FWCustomSheetViewProperty()
        property.popupViewItemHeight = 40
        property.selectedIndex = 1
        let titles = ["EOS", "DICE", "ZKS"]
        let customSheetView = FWCustomSheetView.sheet(headerTitle: "选择代币", itemTitles: titles, itemSecondaryTitles: nil, itemImages: nil, property: property, itemBlock: { (_, index, _) in
            print("customSheet：点击了第\(index)个按钮")
        })
        return customSheetView
    }()

    lazy var customSheetView2: FWCustomSheetView = {

        let property = FWCustomSheetViewProperty()
        property.lastNeedAccessoryView = true
        // 设置默认不选中
        property.selectedIndex = -1

        let titles = ["fdksds123123", "fdksds112233", "导入钱包"]
        let secondaryTitles = ["EOS6sHTCXbm4Gz5WRhKxuuBgVZYttvM9tEdU6ThH6kseMWLYDTk9q", "EOS1sdksbm4Gz5WRhKxuuBgVZYttvM9tEdU6ThH6kseMWLYDTk9q",""]
        let images = [UIImage(named: "right_menu_addFri"),
                      UIImage(named: "right_menu_addFri"),
                      UIImage(named: "right_menu_multichat")]

        let customSheetView = FWCustomSheetView.sheet(headerTitle: "选择一个钱包", itemTitles: titles, itemSecondaryTitles: secondaryTitles, itemImages: images as? [UIImage], property: property, itemBlock: { (_, index, _) in
            print("customSheet：点击了第\(index)个按钮")
        })

        return customSheetView
    }()

    lazy var alertImage: FWAlertView = {
        let block2: FWPopupItemClickedBlock = { [weak self] (popupView, index, title) in
            if index == 1 {
                self?.alertImage.hide()
            }
        }

        // 注意：此时“确定”按钮是不让按钮自己隐藏的
        let items = [FWPopupItem(title: "取消", itemType: .normal, isCancel: true, canAutoHide: true, itemClickedBlock: block2),
                     FWPopupItem(title: "确定", itemType: .normal, isCancel: false, canAutoHide: false, itemClickedBlock: block2)]
        // 注意：添加自定义的视图，需要设置确定的Frame值
        let customImageView = UIImageView(image: UIImage(named: "audio_bgm_4"))
        let vProperty = FWAlertViewProperty()
        let alertImage = FWAlertView.alert(title: "标题", detail: "带自定义视图", inputPlaceholder: nil, keyboardType: .default, isSecureTextEntry: false, customView: customImageView, items: items, vProperty: vProperty)
        return alertImage
    }()

    lazy var sheetView: FWSheetView = {
        let items = ["确定"]
        let vProperty = FWSheetViewProperty()
        vProperty.titleColor = UIColor.lightGray
        vProperty.titleFontSize = 15.0

        let sheetView = FWSheetView.sheet(title: "你们知道微信中为什么经常使用这种提示，而不使用Alert加两个按钮的那种提示吗？", itemTitles: items, itemBlock: { (_, index, _) in
            print("Sheet：点击了第\(index)个按钮")
        }, cancenlBlock: {
            print("点击了取消")
        }, property: vProperty)
        return sheetView
    }()

    lazy var radioButton: FWRadioButton = {

        let property = FWRadioButtonProperty()
        property.selectedStateColor = UIColor.red
        property.animationDuration = 0.2
        property.isAnimated = true
        property.isSelected = true
        property.insideMarginRate = 0.5
        property.isBorderColorNeedChanged = true
        property.lineWidth = 3
        property.radioViewEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 2)

        let radioButton = FWRadioButton.radio(frame: CGRect(x: 0, y: 0, width: 150, height: 40), buttonType: .circular, title: "这个是标题啦", selectedImage: nil, unSelectedImage: nil, property: property, clickedBlock: { (isSelected) in
            print("FWRadioButtonProperty点击了，是否选中：\(isSelected)")
        })
        return radioButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "弹出框列表"
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        FWPopupWindow.sharedInstance.touchWildToHide = true
    }
}

extension FWDemoViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        if indexPath.row == 10 || indexPath.row == 11 {
            cell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 15 {
            cell.accessoryView = self.radioButton
        } else {
            cell.accessoryType = .none
            cell.accessoryView = nil
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let alertView = FWAlertView.alert(title: "", detail: "描述描述描述描述") { (_, _, _) in
                print("点击了确定")
            }
            alertView.show()
        case 1:
            let alertView = FWAlertView.alert(title: "温馨提示", detail: "您确认退出当前账号吗？", confirmBlock: { (_, _, _) in
                print("点击了确定")
            }, cancelBlock: { (_, _, _) in
                print("点击了取消")
            })
            alertView.show()
        case 2:
            // 注意：此时“确定”按钮是不让按钮自己隐藏的
            let items = [
                FWPopupItem(title: "取消", itemType: .normal, isCancel: true, canAutoHide: true, itemTitleColor: kPV_RGBA(r: 141, g: 151, b: 163, a: 1.0), itemBackgroundColor: nil, itemClickedBlock: block),
                FWPopupItem(title: "确定", itemType: .normal, isCancel: false, canAutoHide: true, itemTitleColor: kPV_RGBA(r: 29, g: 150, b: 227, a: 1.0), itemTitleFont: UIFont.systemFont(ofSize: 20.0), itemBackgroundColor: nil, itemClickedBlock: block)
            ]
            let vProperty = FWAlertViewProperty()
            vProperty.alertViewWidth = max(UIScreen.main.bounds.width * 0.65, 275)
            vProperty.titleFont = UIFont.systemFont(ofSize: 17.0)
            vProperty.detailFontSize = 14.0
            vProperty.detailColor = kPV_RGBA(r: 141, g: 151, b: 163, a: 1.0)
            vProperty.buttonFontSize = 14.0
            vProperty.maskViewColor = UIColor(white: 0, alpha: 0.5)
            let alertView = FWAlertView.alert(title: "标题", detail: "描述描述描述描述描述描述描述描述描述描述", inputPlaceholder: nil, keyboardType: .default, isSecureTextEntry: false, customView: nil, items: items, vProperty: vProperty)
            alertView.show { (_, popupViewState) in
                print("当前弹窗状态：\(popupViewState.rawValue)")
                if popupViewState == .didDisappear {
                    print("当前弹窗已经隐藏")
                }
            }
        case 3:
            let myBlock: FWPopupItemClickedBlock = { [weak self] (popupView, index, title) in
                print("AlertView：点击了第\(index)个按钮")
                if index == 2 {
                    self?.sheetView.show()
                }
            }

            let items = [FWPopupItem(title: "取消", itemType: .normal, isCancel: true, canAutoHide: true, itemClickedBlock: myBlock),
                         FWPopupItem(title: "确定", itemType: .normal, isCancel: false, canAutoHide: true, itemClickedBlock: myBlock),
                         FWPopupItem(title: "弹出Sheet", itemType: .normal, isCancel: false, canAutoHide: true, itemClickedBlock: myBlock)]

            let alertView = FWAlertView.alert(title: "标题", detail: "描述描述描述描述描述描述描述描述描述描述", inputPlaceholder: nil, keyboardType: .default, isSecureTextEntry: false, customView: nil, items: items)
            alertView.show()
        case 4:
            let items = [FWPopupItem(title: "取消", itemType: .normal, isCancel: true, canAutoHide: true, itemClickedBlock: block),
                         FWPopupItem(title: "确定", itemType: .normal, isCancel: false, canAutoHide: true, itemClickedBlock: block)]

            let alertView = FWAlertView.alert(title: "请输入审批意见", detail: "", inputPlaceholder: "请输入...", keyboardType: .numberPad, isSecureTextEntry: false, customView: nil, items: items)
            alertView.show()
        case 5:
            self.alertImage.show()
        case 6:
            let items = ["Sheet0", "Sheet1", "Sheet2", "Sheet3"]

            let vProperty = FWSheetViewProperty()
            vProperty.cancelItemTitleColor = UIColor.red

            let sheetView = FWSheetView.sheet(title: "", itemTitles: items, itemBlock: { (_, index, _) in
                print("Sheet：点击了第\(index)个按钮")
            }, cancenlBlock: {
                print("点击了取消")
            }, property: vProperty)
            sheetView.show()
        case 7:
            self.sheetView.show()
        case 8:
            let items = ["Sheet0", "Sheet1", "Sheet2", "Sheet3", "Sheet4", "Sheet5", "Sheet6", "Sheet7", "Sheet8", "Sheet9", "Sheet10", "Sheet11", "Sheet12", "Sheet13", "Sheet14"]

            let sheetView = FWSheetView.sheet(title: "标题", itemTitles: items, itemBlock: { (_, index, title) in
                print("Sheet：点击了第\(index)个按钮，名称为：\(String(describing: title))")
            }, cancelBlock: {
                print("点击了取消")
            })
            sheetView.show()
        case 9:
            self.navigationController?.pushViewController(FWMenuViewDemoVC(), animated: true)
        case 10:
            self.navigationController?.pushViewController(FWCustomPopupDemoVC(), animated: true)
        case 11:
            self.customSheetView.show()
        case 12:
            self.customSheetView2.show()
        case 13:
            let alertView = FWAlertView.alert(title: "标题", detail: "描述描述描述描述") { (_, _, _) in
                print("点击了确定")
            }
            alertView.show { (_, popupViewState) in
                print("当前alertView状态：\(popupViewState.rawValue)")
            }

            let items = ["Sheet0", "Sheet1", "Sheet2", "Sheet3"]
            let vProperty = FWSheetViewProperty()
            let sheetView = FWSheetView.sheet(title: "", itemTitles: items, itemBlock: { (_, index, _) in
                print("Sheet：点击了第\(index)个按钮")
            }, cancenlBlock: {
                print("点击了取消")
            }, property: vProperty)
            sheetView.show()
        case 14:
            self.radioButton.isSelected = !self.radioButton.isSelected
        case 15:
            let property = FWRadioButtonProperty()
            property.animationDuration = 0.2
            property.isAnimated = true
            property.isSelected = true
            property.radioViewEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 2)

            let radioButton = FWRadioButton.radio(frame: CGRect(x: 0, y: 0, width: 260, height: 35), buttonType: .image, title: "勾选表示记住当前状态哦！！！", selectedImage: nil, unSelectedImage: nil, property: property, clickedBlock: { (isSelected) in
                print("FWRadioButtonProperty点击了，是否选中：\(isSelected)")
            })

            let block: FWPopupItemClickedBlock = { (popupView, index, title) in
                print("AlertView：点击了第\(index)个按钮")
                popupView.hide()
            }

            // 注意：此时“确定”按钮是不让按钮自己隐藏的
            let items = [FWPopupItem(title: "取消", itemType: .normal, isCancel: true, canAutoHide: true, itemClickedBlock: block),
                         FWPopupItem(title: "确定", itemType: .normal, isCancel: false, canAutoHide: false, itemClickedBlock: block)]

            let alertView = FWAlertView.alert(title: "温馨提示", detail: "是否记住当前状态？", inputPlaceholder: nil, keyboardType: .default, isSecureTextEntry: false, customView: radioButton, items: items)
            alertView.show()
        default:
            break
        }
    }
}
