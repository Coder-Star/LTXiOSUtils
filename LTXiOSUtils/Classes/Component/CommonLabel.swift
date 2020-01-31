//
//  CommonLabel.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/1/19.
//

import Foundation

public class CommonLabel: UILabel {

    public var canCopy: Bool = true {
        didSet {
            setCopy()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setCopy()
        addObserver()
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

    @objc private func customCopy(_ sender: Any?) {
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
}

extension CommonLabel {

    private func addObserver() {
        let observingKeys = ["attributedText","text"]
        for key in observingKeys {
            self.addObserver(self, forKeyPath: key, options: .new, context: nil)
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        setEvent()
    }

    @objc private func setEvent() {
        guard let str = self.text else {
            return
        }
        if str.isMobile || str.isEmail {
            self.textColor = .blue
            self.addTapGesture { _ in
                
            }
        }
    }
}
