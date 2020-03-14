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
        self.addTapGesture { [weak self] _ in
            self?.clickCallBack?()
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension SuspensionButton {
    func show() {
        
    }

    func hide() {

    }
}

private extension SuspensionButton {

}
