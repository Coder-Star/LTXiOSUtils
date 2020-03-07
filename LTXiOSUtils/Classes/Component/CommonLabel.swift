//
//  CommonLabel.swift
//  LTXiOSUtils
//
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

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setCopy()
        addTextObserver()
    }

    private func setupView() {

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
        if canCopy {
            self.addLongPressGesture { _ in
                self.becomeFirstResponder()
                let copyItem = UIMenuItem(title: "复制", action: #selector(self.customCopy(_:)))
                let menu = UIMenuController.shared
                menu.menuItems = [copyItem]
                if menu.isMenuVisible {
                    return
                }
                if let superV = self.superview {
                    menu.setTargetRect(self.frame, in: superV)
                }
                menu.setMenuVisible(true, animated: true)
            }
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

    private func addTextObserver() {
        let observingKeys = ["attributedText","text"]
        for key in observingKeys {
            self.addObserver(self, forKeyPath: key, options: .new, context: nil)
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        setEvent()
    }

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
                    self.addTapGesture { _ in
                        self.click(type: type, str: str)
                    }
                }
            case .email:
                if str.isEmail {
                    self.textColor = checkType[type]
                    self.addTapGesture { _ in
                        self.click(type: type, str: str)
                    }
                }
            case .networkUrl:
                if str.isNetworkUrl {
                    self.textColor = checkType[type]
                    self.addTapGesture { _ in
                        self.click(type: type, str: str)
                    }
                }
            }
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
        } else {
            HUD.showText("链接打开失败")
        }
    }
}
