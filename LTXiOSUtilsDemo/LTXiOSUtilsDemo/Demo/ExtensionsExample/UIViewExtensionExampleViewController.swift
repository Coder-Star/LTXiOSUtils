//
//  UIViewExtensionExampleViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/1/7.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

class UIViewExtensionExampleViewController: BaseUIScrollViewController {

    private let leftWidth = 110

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "View相关扩展示例Demo"
    }

    override func setScrollSubViews(contentView: UIView) {
        var titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "View点击"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(leftWidth)
        }

        let redView = UIView()
        redView.backgroundColor = .red
        contentView.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(titleLabel)
            make.height.equalTo(30)
        }
        redView.addTapGesture { _ in
           QL1("点击")
        }

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "Button点击"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(redView.snp.bottom).offset(10)
            make.width.equalTo(leftWidth)
        }

        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("点击", for: .normal)
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(titleLabel)
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
//        button.addTouchUpInsideAction { _ in
//            QL1("点击")
//        }
        button.addAction(event: .touchUpInside) { _ in
            QL1("点击")
        }

    }
}
