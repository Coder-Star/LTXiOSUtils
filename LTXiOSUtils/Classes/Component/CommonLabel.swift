//
//  CommonLabel.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/1/19.
//

import Foundation

public class CommonLabel: UILabel {

    var canCopy: Bool = true {
        didSet {
            setCopy()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setCopy()
    }

    private func setupView() {

    }

    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(self.copy(_:)) {
            return true
        } else {
            return false
        }
    }
    public override func copy(_ sender: Any?) {
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
                let copyItem = UIMenuItem(title: "复制", action: #selector(self.copy(_:)))
                let menu = UIMenuController.shared
                menu.menuItems = [copyItem]
                if menu.isMenuVisible {
                    return
                }
                menu.setTargetRect(self.bounds, in: self)
                menu.setMenuVisible(true, animated: true)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
