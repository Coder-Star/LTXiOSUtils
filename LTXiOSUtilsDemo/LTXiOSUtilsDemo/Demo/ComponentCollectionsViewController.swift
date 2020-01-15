//
//  ComponentCollectionsViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/1/1.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import UIKit
import LTXiOSUtils

class ComponentCollectionsViewController: BaseUIScrollViewController {

    private let leftWidth = 110

    /// 加载按钮
    lazy var spinnerBtn: SpinnerButton = {
        let spinnerBtn = SpinnerButton()
        spinnerBtn.defaultCornerRadius = 5
        spinnerBtn.title = "登录"
        return spinnerBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "控件集锦"
    }

    override func setScrollSubViews(contentView: UIView) {
        var titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "加载按钮"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(leftWidth)
        }

        contentView.addSubview(spinnerBtn)
        spinnerBtn.tag = 1
        spinnerBtn.addTarget(self, action: #selector(btnClick(button:)), for: .touchUpInside)
        spinnerBtn.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(titleLabel)
        }

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "TextView"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(spinnerBtn.snp.bottom).offset(10)
            make.width.equalTo(leftWidth)
        }

        let textView = ViewFactory.getTextView()
        textView.placeholder = "请输入信息，这是UITextView的扩展"
        textView.limitLength = 10
//        textView.limitLines = 1
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel)
        }

        textView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
}

extension ComponentCollectionsViewController {
    @objc func btnClick(button: UIButton) {
        switch button.tag {
        case 1:
            spinnerBtn.animate(animation: .load)
            DispatchQueue.main.delay(1) {
                self.spinnerBtn.animate(animation: .default)
            }
            DispatchQueue.main.delay(1.3) {
                self.spinnerBtn.animate(animation: .shake)
            }

        default:
            QL1("未知点击事件")
        }
    }
}
