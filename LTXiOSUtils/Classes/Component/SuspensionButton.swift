//
//  SuspensionButton.swift
//  LTXiOSUtils
//  悬浮按钮
//  Created by 李天星 on 2020/3/11.
//

import Foundation

open class SuspensionButton: UIView {
    public typealias ClickCallBack = () -> Void
    public var clickCallBack: ClickCallBack?

    private let currentWindow = UIApplication.shared.delegate?.window

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.addTapGesture { [weak self] _ in
            self?.clickCallBack?()
        }
    }

}

public extension SuspensionButton {
    /// 展示
    func show() {

    }

    /// 隐藏
    func hide() {

    }
}

private extension SuspensionButton {

}
