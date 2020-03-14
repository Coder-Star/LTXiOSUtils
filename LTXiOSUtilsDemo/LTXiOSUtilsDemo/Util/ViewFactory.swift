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
        normalUIButton.layer.borderColor = UIColor(hexString: "#cdcdcd").cgColor
        normalUIButton.layer.borderWidth = 0.5
        normalUIButton.layer.cornerRadius = 5
        normalUIButton.layer.backgroundColor = UIColor(hexString: "#eeeeee").cgColor
        normalUIButton.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        return normalUIButton
    }

    /// 获取UITextView
    class func getTextView() -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.layer.borderColor = UIColor(hexString: "#cdcdcd").cgColor
        textView.returnKeyType = .done
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5
        textView.textColor = UIColor.black
        textView.backgroundColor = .white
        textView.snp.makeConstraints { (make) in
            make.height.equalTo(70)
        }
        return textView
    }

}

extension ViewFactory {
    
}
