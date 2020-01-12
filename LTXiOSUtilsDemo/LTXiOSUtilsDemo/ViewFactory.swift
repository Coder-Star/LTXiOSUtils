//
//  ViewFactory.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/1/1.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import UIKit

/// 快速创建控件
public class ViewFactory {

}

public extension ViewFactory {
    /// 创建UIlabel
    class func createLabel() {

    }

    /// 获取普通按钮
    /// - Parameter title: 标题
    class func getButton(_ title :String) -> UIButton {
        let normalUIButton = UIButton()
        normalUIButton.setTitle(title, for: .normal)
        normalUIButton.titleLabel?.textAlignment = .center
        normalUIButton.titleLabel?.adjustsFontSizeToFitWidth = true
        normalUIButton.setTitleColor(.black, for: .normal)
        normalUIButton.layer.borderColor = UIColor.gray.cgColor
        normalUIButton.layer.borderWidth = 0.5
        normalUIButton.layer.cornerRadius = 5
        normalUIButton.layer.backgroundColor = UIColor.lightGray.cgColor
        normalUIButton.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        return normalUIButton
    }

}
