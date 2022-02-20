//
//  ScrollPageControlView.swift
//  LTXiOSUtils
//  横向滚动分页控件
//  Created by CoderStar on 2020/1/15.
//

import Foundation
import UIKit

open class ScrollPageControlView: UIView {
    /// 偏移量
    public var progrss: CGFloat = 0 {
        didSet {
            var frame = currentIndicatorView.frame
            frame.origin.x = progrss
            currentIndicatorView.frame = frame
        }
    }

    /// 滑块宽度
    public var currentIndicatorWidth: CGFloat = 20 {
        didSet {
            var frame = currentIndicatorView.frame
            frame.size.width = currentIndicatorWidth
            currentIndicatorView.frame = frame
        }
    }

    /// 滑块颜色
    public var currentIndicatorColor = UIColor(hexString: "#4296d5") {
        didSet {
            currentIndicatorView.backgroundColor = currentIndicatorColor
        }
    }

    /// 计算偏移量
    public var offsetWidth: CGFloat {
        return frame.width - currentIndicatorWidth
    }

    private lazy var currentIndicatorView: UIView = {
        let currentIndicatorView = UIView()
        return currentIndicatorView
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(currentIndicatorView)
        backgroundColor = UIColor(hexString: "#eeeeee")
    }

    override open func layoutSubviews() {
        layer.masksToBounds = true
        layer.cornerRadius = frame.height / 2
        currentIndicatorView.frame = CGRect(x: 0, y: 0, width: currentIndicatorWidth, height: frame.height)
        currentIndicatorView.backgroundColor = currentIndicatorColor
        currentIndicatorView.layer.masksToBounds = true
        currentIndicatorView.layer.cornerRadius = currentIndicatorView.frame.height / 2
    }
}
