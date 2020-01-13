//
//  PageControl.swift
//  LTXiOSUtils
//  多页控件
//  Created by 李天星 on 2019/11/21.
//

import UIKit

/// PageControl样式
public enum PageControlStyle {
    /// 类似苹果原生效果
    case original(circleSize: CGFloat)
    /// 方块样式
    case square(size: CGSize)
    /// 大小切换样式
    case bigSmall(bigSize: CGSize, smallSize: CGSize)
    /// 环形样式
    case ring(circleSize: CGFloat)
    /// 数字样式
    case number(font: UIFont, color: UIColor)
}

open class PageControl: UIView {

    /// 总共有多少页(默认0页)
    open var numberOfPages = 0
    /// 当前是第几页
    open var currentPage = 0 {
        didSet {
            setPage()
        }
    }
    /// 普通状态的颜色
    open var normorlColor: UIColor = UIColor.lightGray
    /// 当前页的颜色
    open var currentColor: UIColor = UIColor.white
    /// 样式
    open var style: PageControlStyle = .square(size: CGSize(width: 15, height: 5)) {
        didSet {
            setCurrentAndNormalSize()
        }
    }
    /// 间距
    open var margin: CGFloat = 5

    /// 普通状态的尺寸
    private var normalSize = CGSize.zero
    /// 当前状态的尺寸
    private var currentSize = CGSize.zero
    /// 数字样式tag
    private let curLabelTag = -100000

    private lazy var numberLabel: UILabel = {
        let numberLabel = UILabel(frame: CGRect.zero)
        numberLabel.textAlignment = .center
        return numberLabel
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setCurrentAndNormalSize()
        self.tag = -999
        backgroundColor = UIColor.clear
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutPages() {
        if numberOfPages <= 0 { return }
        switch style {
        case .original, .square, .ring:
            layoutOrgPages()
        case .bigSmall:
            layoutBigSmallPages()
        case .number:
            layoutNumberPages()
        }
    }

    private func setCurrentAndNormalSize() {
        switch style {
        case .original(let circleSize):
            normalSize = CGSize(width: circleSize, height: circleSize)
            currentSize = CGSize(width: circleSize, height: circleSize)
        case .square(let size):
            normalSize = size
            currentSize = size
        case .ring(let circleSize):
            normalSize = CGSize(width: circleSize, height: circleSize)
            currentSize = CGSize(width: circleSize, height: circleSize)
        case .bigSmall(let bigSize, let smallSize):
            currentSize = bigSize
            normalSize = smallSize
        case .number(let font, let color):
            numberLabel.font = font
            numberLabel.textColor = color
            numberLabel.tag = curLabelTag
            numberLabel.frame = CGRect(x: 0.cgFloatValue, y: 0.cgFloatValue, width: 100, height: 25)
        }
    }

    // 布局默认样式 ring样式 square样式
    private func layoutOrgPages() {
        let y: CGFloat = (self.frame.height - normalSize.height)*0.5
        for i in 0..<numberOfPages {
            let point = UIView(frame: CGRect(x: CGFloat(i) * (margin + normalSize.width) + margin, y: y, width: normalSize.width, height: normalSize.height))
            point.tag = i
            point.backgroundColor = i == currentPage ? currentColor : normorlColor
            switch style {
            case .original(let circleSize):
                point.layer.cornerRadius = circleSize * 0.5
                point.layer.masksToBounds = true
            case .square:
                if i != currentPage {
                    point.backgroundColor = UIColor.clear
                    point.layer.borderWidth = 1.0
                    point.layer.borderColor = normorlColor.cgColor
                } else {
                    point.backgroundColor = currentColor
                }
                point.layer.cornerRadius = 2
                point.layer.masksToBounds = true

            case .ring:
                if i != currentPage {
                    point.backgroundColor = UIColor.clear
                    point.layer.borderWidth = 1.0
                    point.layer.borderColor = normorlColor.cgColor
                } else {
                    point.backgroundColor = currentColor
                }
                point.layer.cornerRadius = normalSize.height * 0.5
                point.layer.masksToBounds = true
            default:
                break
            }
            self.addSubview(point)
        }
    }

    // 布局bigSmall样式
    private func layoutBigSmallPages() {
        let y1: CGFloat = (self.frame.height - normalSize.height)*0.5
        let y2: CGFloat = (self.frame.height - currentSize.height)*0.5
        for i in 0..<numberOfPages {
            var pointX = 0.cgFloatValue
            if i <= currentPage {
                pointX = i.cgFloatValue * (margin + normalSize.width) + margin
            } else {
                pointX = i.cgFloatValue * margin + (i - 1).cgFloatValue * normalSize.width + currentSize.width + margin
            }
            let pointY = i == currentPage ? y2 : y1
            let pointW = i == currentPage ? currentSize.width : normalSize.width
            let pointH = i == currentPage ? currentSize.height : normalSize.height
            let point = UIView(frame: CGRect(x: pointX, y: pointY, width: pointW, height: pointH))
            print(point)
            point.tag = i
            point.backgroundColor = i == currentPage ? currentColor : normorlColor
            point.layer.cornerRadius = i == currentPage ? currentSize.height * 0.5 : normalSize.height * 0.5
            point.layer.masksToBounds = true
            self.addSubview(point)
        }
    }

    // 布局number样式
    private func layoutNumberPages() {
        numberLabel.text = "\(currentPage + 1) / \(numberOfPages)"
        self.addSubview(numberLabel)
    }

    // 页码切换
    private func setPage() {
        if self.subviews.isEmpty { return }
        if currentPage > numberOfPages, currentPage < 0 { return }
        switch style {
        case .original, .bigSmall, .square :
            for view in self.subviews {
                view.backgroundColor = normorlColor
                switch style {
                case .bigSmall:
                    view.bounds = CGRect(x: 0, y: 0, width: normalSize.width, height: normalSize.height)
                    view.layer.cornerRadius = normalSize.width * 0.5
                    view.layer.masksToBounds = true
                case .square:
                    view.layer.cornerRadius = 2
                    view.layer.masksToBounds = true
                    view.layer.borderWidth = 1.0
                    view.layer.borderColor = normorlColor.cgColor
                    view.backgroundColor = UIColor.clear
                default:
                    break
                }
            }
            let curView = self.viewWithTag(currentPage)!
            curView.backgroundColor = currentColor
            switch style {
            case .bigSmall:
                curView.bounds = CGRect(x: 0, y: 0, width: currentSize.width, height: currentSize.height)
                curView.layer.cornerRadius = currentSize.width * 0.5
                curView.layer.masksToBounds = true
            case .square:
                curView.layer.borderWidth = 0
            default:
                break
            }
        case .ring:
            for view in self.subviews {
                view.backgroundColor = UIColor.clear
                view.layer.borderWidth = 1.0
                view.layer.borderColor = normorlColor.cgColor
            }
            let curView = self.viewWithTag(currentPage)!
            curView.backgroundColor = currentColor
            curView.layer.borderWidth = 0
        case .number:
            if let label = self.viewWithTag(curLabelTag) as? UILabel {
                label.text = "\(currentPage + 1) / \(numberOfPages)"
            }
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clear
        if self.subviews.isEmpty {
            layoutPages()
        }
    }
}

extension PageControl {
    var frameSize: CGSize {
        if numberLabel.frame != .zero {
            return numberLabel.frame.size
        }
        let frameWidth = currentSize.width + (numberOfPages - 1).cgFloatValue * normalSize.width + (numberOfPages + 1).cgFloatValue * margin
        let frameHeight = max(currentSize.height , normalSize.height) + 5
        return CGSize(width: frameWidth, height: frameHeight)
    }
}
