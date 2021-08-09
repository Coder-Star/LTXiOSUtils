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
            var frame = self.currentIndicatorView.frame
            frame.origin.x = progrss
            self.currentIndicatorView.frame = frame
        }
    }

    /// 滑块宽度
    public var currentIndicatorWidth: CGFloat = 20 {
        didSet {
            var frame = self.currentIndicatorView.frame
            frame.size.width = currentIndicatorWidth
            self.currentIndicatorView.frame = frame
        }
    }

    /// 滑块颜色
    public var currentIndicatorColor = UIColor(hexString: "#4296d5") {
        didSet {
            self.currentIndicatorView.backgroundColor = currentIndicatorColor
        }
    }

    /// 计算偏移量
    public var offsetWidth: CGFloat {
        return self.frame.width - self.currentIndicatorWidth
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
        self.addSubview(currentIndicatorView)
        self.backgroundColor = UIColor(hexString: "#eeeeee")
    }

    override open func layoutSubviews() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.currentIndicatorView.frame = CGRect(x: 0, y: 0, width: currentIndicatorWidth, height: self.frame.height)
        self.currentIndicatorView.backgroundColor = currentIndicatorColor
        self.currentIndicatorView.layer.masksToBounds = true
        self.currentIndicatorView.layer.cornerRadius = self.currentIndicatorView.frame.height / 2
    }
}
