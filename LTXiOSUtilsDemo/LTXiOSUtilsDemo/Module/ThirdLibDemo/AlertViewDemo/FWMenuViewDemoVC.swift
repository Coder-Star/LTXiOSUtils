//
//  FWMenuViewDemoVC.swift
//  FWPopupView
//
//  Created by xfg on 2018/5/24.
//  Copyright © 2018年 xfg. All rights reserved.
//

import Foundation
import UIKit
import LTXiOSUtils

/// 状态栏高度
let kStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
/// 导航栏高度
let kNavBarHeight: CGFloat = 44.0

class FWMenuViewDemoVC: BaseUIViewController {

    let titles = ["创建群聊", "加好友/群", "扫一扫", "面对面快传", "付款", "拍摄"]
    let images = [UIImage(named: "right_menu_multichat"),
                  UIImage(named: "right_menu_addFri"),
                  UIImage(named: "right_menu_QR"),
                  UIImage(named: "right_menu_facetoface"),
                  UIImage(named: "right_menu_payMoney"),
                  UIImage(named: "right_menu_sendvideo")]

    let images2 = [UIImage(named: "right_menu_multichat_white"),
                   UIImage(named: "right_menu_addFri_white"),
                   UIImage(named: "right_menu_QR_white"),
                   UIImage(named: "right_menu_facetoface_white"),
                   UIImage(named: "right_menu_payMoney_white"),
                   UIImage(named: "right_menu_sendvideo_white")]

    lazy var menuView1: FWMenuView = {
        let vProperty = FWMenuViewProperty()
        vProperty.popupCustomAlignment = .topCenter
        vProperty.popupViewMinWidth = Constants.Size.WIDTH
        vProperty.popupAnimationType = .frame
        vProperty.popupArrowStyle = .none
        vProperty.topBottomMargin = 10
        vProperty.cornerRadius = 0
        vProperty.selectionStyle = .gray
        vProperty.maskViewColor = UIColor(white: 0, alpha: 0.3)
        let menuView = FWMenuView.menu(itemTitles: titles, itemImageNames: nil, property: vProperty) { (_, index, _) in
            Log.d("Menu：点击了第\(index)个按钮")
        }
        menuView.attachedView = self.baseView
        return menuView
    }()

    lazy var menuView2: FWMenuView = {
        let vProperty = FWMenuViewProperty()
        vProperty.popupCustomAlignment = .topRight
        vProperty.popupAnimationType = .scale
        vProperty.maskViewColor = .clear
        vProperty.popupViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        vProperty.topBottomMargin = 0
        vProperty.animationDuration = 0.3
        vProperty.popupArrowStyle = .round
        vProperty.popupArrowVertexScaleX = 1
        vProperty.backgroundColor = kPV_RGBA(r: 64, g: 63, b: 66, a: 1)
        vProperty.splitColor = kPV_RGBA(r: 64, g: 63, b: 66, a: 1)
        vProperty.separatorColor = kPV_RGBA(r: 91, g: 91, b: 93, a: 1)
        vProperty.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.backgroundColor: UIColor.clear, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
        vProperty.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

        let menuView = FWMenuView.menu(itemTitles: titles, itemImageNames: images2 as? [UIImage], property: vProperty) { (_, index, _) in
            Log.d("Menu：点击了第\(index)个按钮")
        }
        menuView.attachedView = self.baseView
        return menuView
    }()

    var centerBtn: UIButton!
    var leftBottomBtn: UIButton!
    var rightBottomBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        let buttonItem: UIBarButtonItem = UIBarButtonItem(image: R.image.add(), style: .plain, target: self, action: #selector(barBtnAction(_:)))
        buttonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -6)
        self.navigationItem.rightBarButtonItem = buttonItem

        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        btn.setTitle("下拉▼", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.tag = 0
        self.navigationItem.titleView = btn

        centerBtn = self.setupBtn(title: "中间按钮", tag: 1) as? UIButton
        self.baseView.addSubview(centerBtn)
        centerBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview().inset(UIEdgeInsets(top: -100, left: 0, bottom: 0, right: 0))
            make.size.equalTo(CGSize(width: 100, height: 50))
        }

        leftBottomBtn = self.setupBtn(title: "左下角按钮", tag: 2) as? UIButton
        self.baseView.addSubview(leftBottomBtn)
        leftBottomBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 200, height: 50))
        }

        rightBottomBtn = self.setupBtn(title: "右下角按钮", tag: 3) as? UIButton
        self.baseView.addSubview(rightBottomBtn)
        rightBottomBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
    }
}

extension FWMenuViewDemoVC {

    func setupBtn(title: String, tag: Int) -> UIView {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.backgroundColor = UIColor.lightGray
        btn.tag = tag
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        return btn
    }

    @objc func btnAction(_ sender: UIButton) {
        let btn = sender
        switch btn.tag {
        case 0:
            if self.menuView1.visible {
                self.menuView1.hide()
            } else {
                self.menuView1.show()
            }
        case 1:
            let property = FWMenuViewProperty()
            property.popupCustomAlignment = .topCenter
            property.popupAnimationType = .scale
            property.maskViewColor = UIColor.clear
            property.popupViewEdgeInsets = UIEdgeInsets(top: self.centerBtn.frame.maxY + kStatusBarHeight + kNavBarHeight, left: 0, bottom: 0, right: 0)
            property.topBottomMargin = 10
            property.animationDuration = 0.3
            property.popupArrowStyle = .round
            property.popupArrowVertexScaleX = 0.5
            property.cornerRadius = 5
            let menuView = FWMenuView.menu(itemTitles: titles, itemImageNames: nil, property: property, itemBlock: { (_, index, _) in
                Log.d("Menu：点击了第\(index)个按钮")
            })
            menuView.show()
        case 2:
            let property = FWMenuViewProperty()
            property.popupCustomAlignment = .bottomLeft
            property.popupAnimationType = .frame
            property.maskViewColor = UIColor(white: 0, alpha: 0.4)
            property.popupViewEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: UIScreen.main.bounds.height - self.leftBottomBtn.frame.minY - kStatusBarHeight - kNavBarHeight, right: 0)
            property.topBottomMargin = 10
            property.animationDuration = 0.3
            property.popupArrowStyle = .none
            property.cornerRadius = 0
            property.popupViewMinWidth = 200
            property.popupViewMaxHeightRate = 0.7
            let titles = ["Menu011111", "Menu1", "Menu2", "Menu3", "Menu4", "Menu5", "Menu6", "Menu7", "Menu8", "Menu9", "Menu10", "Menu11", "Menu12", "Menu13", "Menu14", "Menu15", "Menu16"]
            let menuView = FWMenuView.menu(itemTitles: titles, itemImageNames: nil, property: property, itemBlock: { (_, index, _) in
                Log.d("Menu：点击了第\(index)个按钮")
            })
            menuView.attachedView = baseView
            menuView.show()
        case 3:
            let property = FWMenuViewProperty()
            property.popupCustomAlignment = .bottomRight
            property.popupAnimationType = .scale
            property.maskViewColor = UIColor.clear
            property.popupViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.main.bounds.height - self.leftBottomBtn.frame.minY - kStatusBarHeight - kNavBarHeight, right: 10)
            property.topBottomMargin = 0
            property.animationDuration = 0.3
            property.popupArrowStyle = .round
            property.popupArrowVertexScaleX = 0.8
            property.cornerRadius = 5

            let menuView = FWMenuView.menu(itemTitles: titles, itemImageNames: images as? [UIImage], property: property, itemBlock: { (_, index, _) in
                Log.d("Menu：点击了第\(index)个按钮")
            })
            menuView.show()
        default:
            break
        }
    }

    @objc func barBtnAction(_ sender: Any) {
       if self.menuView2.visible {
            self.menuView2.hide()
        } else {
            self.menuView2.show()
        }
    }
}