//
//  CommonLabel.swift
//  LTXiOSUtils
//  通用Label，支持复制功能，支持电话、邮箱、网络url等进行跳转
//  Created by 李天星 on 2020/1/19.
//

import Foundation

/// CommonLabel支持的可点击跳转的类型
public enum CommonLabelUrlType {
    /// 电话
    case mobile
    /// 邮箱
    case email
    /// 网络url
    case networkUrl
}

public class CommonLabel: UILabel {

    public var checkType: [CommonLabelUrlType:UIColor] = [
        CommonLabelUrlType.mobile:UIColor.blue,
        CommonLabelUrlType.email:UIColor.blue,
        CommonLabelUrlType.networkUrl:UIColor.blue
    ]

    public var canCopy: Bool = true {
        didSet {
            setCopy()
        }
    }

    override public var attributedText: NSAttributedString? {
        didSet {
            setEvent()
        }
    }

    override public var text: String? {
        didSet {
            setEvent()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setCopy()
    }

    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(self.customCopy(_:)) {
            return true
        } else {
            return false
        }
    }

    @objc
    private func customCopy(_ sender: Any?) {
        let pBoard = UIPasteboard.general
        pBoard.string = self.text
    }

    public override var canBecomeFirstResponder: Bool {
        return true
    }

    private func setCopy() {
        let menu = UIMenuController.shared
        if canCopy {
            self.addLongPressGesture { _ in
                self.becomeFirstResponder()
                let copyItem = UIMenuItem(title: "复制", action: #selector(self.customCopy(_:)))
                menu.menuItems = [copyItem]
                if menu.isMenuVisible {
                    return
                }
                if let superV = self.superview {
                    let size = self.sizeThatFits(.zero)
                    menu.setTargetRect(CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: size.width, height: size.height), in: superV)
                }
                menu.setMenuVisible(true, animated: true)
            }
        } else {
            menu.setMenuVisible(false, animated: true)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CommonLabel {

    @objc
    private func setEvent() {
        guard let str = self.text else {
            return
        }
        let typeList = Array(checkType.keys)
        for type in typeList {
            switch type {
            case .mobile:
                if str.isMobile {
                    self.textColor = checkType[type]
                    setTapGesture(type: type, str: str)
                }
            case .email:
                if str.isEmail {
                    self.textColor = checkType[type]
                    setTapGesture(type: type, str: str)
                }
            case .networkUrl:
                if str.isNetworkUrl {
                    self.textColor = checkType[type]
                    setTapGesture(type: type, str: str)
                }
            }
        }
    }

    private func setTapGesture(type: CommonLabelUrlType, str: String) {
        /// 使点击手势只在点击文字时生效
        self.addTapGesture { tap in
            let size = self.sizeThatFits(.zero)
            let tapPoint = tap.location(in: self)
            if tapPoint.x > size.width || tapPoint.y > size.height {
                return
            }
            self.click(type: type, str: str)
        }
    }

    private func click(type: CommonLabelUrlType, str: String) {
        var result = ""
        switch type {
        case .mobile:
            result = "tel://\(str)"
        case .email:
            result = "mailto:\(str)"
        case .networkUrl:
            result = str
        }
        if let url = URL(string: result), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
