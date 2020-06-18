//
//  CommonShowTextView.swift
//  LTXiOSUtils
//  通用Label，支持复制功能，支持电话、邮箱、网络url等进行跳转
//  Created by 李天星 on 2020/1/19.
//

import Foundation

/// CommonLabel支持的可点击跳转的类型
public enum CommonShowTextViewUrlType {
    /// 电话
    case mobile
    /// 邮箱
    case email
    /// 网络url
    case networkUrl
}

public class CommonShowTextView: UITextView {

    /// 检查类型
    public var checkType: [CommonShowTextViewUrlType: UIColor] = [
        CommonShowTextViewUrlType.mobile: UIColor.blue,
        CommonShowTextViewUrlType.email: UIColor.blue,
        CommonShowTextViewUrlType.networkUrl: UIColor.blue
        ] {
        didSet {
            setEvent()
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

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
        self.isScrollEnabled = false
        self.isEditable = false
        self.isSelectable = true
        self.font = UIFont.systemFont(ofSize: 17)
        self.textContainer.lineBreakMode = .byCharWrapping
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CommonShowTextView {

    @objc
    private func setEvent() {
        guard let str = self.text else {
            return
        }
        let typeList = Array(checkType.keys)

        if str.tx.isMobile, typeList.contains(.mobile) {
            self.textColor = checkType[.mobile]
            setTapGesture(type: .mobile, str: str)
        } else if str.tx.isEmail, typeList.contains(.email) {
            self.textColor = checkType[.email]
            setTapGesture(type: .email, str: str)
        } else if str.tx.isNetworkUrl, typeList.contains(.networkUrl) {
            self.textColor = checkType[.networkUrl]
            setTapGesture(type: .networkUrl, str: str)
        } else {
            self.textColor = nil
            self.addTapGesture { _ in
                Log.d("点击")
            }
        }
    }

    private func setTapGesture(type: CommonShowTextViewUrlType, str: String) {
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

    private func click(type: CommonShowTextViewUrlType, str: String) {
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
