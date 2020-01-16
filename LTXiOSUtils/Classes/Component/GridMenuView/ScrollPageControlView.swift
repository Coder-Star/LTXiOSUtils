//
//  ScrollPageControlView.swift
//  LTXiOSUtils
//  横向滚动分页控件
//  Created by 李天星 on 2020/1/15.
//

import Foundation

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

        }
    }

    /// 滑块颜色
    public var currentIndicatorColor: UIColor = .blue {
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
        print(frame)
        self.addSubview(currentIndicatorView)
        self.backgroundColor = .lightGray
    }

    override open func layoutSubviews() {
        print("layoutSubviews")
        print(frame)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.currentIndicatorView.frame = CGRect(x: 0, y: 0, width: currentIndicatorWidth, height: self.frame.height)
        self.currentIndicatorView.backgroundColor = currentIndicatorColor
        self.currentIndicatorView.layer.masksToBounds = true
        self.currentIndicatorView.layer.cornerRadius = self.currentIndicatorView.frame.height / 2
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
