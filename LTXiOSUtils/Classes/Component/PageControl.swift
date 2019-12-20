//
//  PageControl.swift
//  LTXiOSUtils
//  多页控件
//  Created by 李天星 on 2019/11/21.
//

import UIKit

enum PageControlStyle {
    case original      // 类似苹果原生效果
    case square        // 方块样式
    case bigSmall      // 大小切换样式
    case ring          // 环形样式
    case number        // 数字样式
}

private let curLabelTag = 100

class PageControl: UIView {

    // 总共有多少页(默认0页)
    open var numberOfPages = 0
    // 当前是第几页
    open var currentPage = 0 {
        didSet {
            setPage()
        }
    }
    // 普通状态的颜色
    open var normorlColor: UIColor = UIColor.lightGray
    // 当前页的颜色
    open var currentColor: UIColor = UIColor.white
    // 普通状态的尺寸
    open var normalSize: CGSize = CGSize(width: 10, height: 10)
    // 当前状态的尺寸(适用于bigSmall样式)
    open var currentSize: CGSize = CGSize(width: 10, height: 10)
    // 当前页字体(number 样式专用)
    open var currentFont: CGFloat = 17
    // 普通页字体(number 样式专业)
    open var normalFont: CGFloat = 14

    // 间距
    fileprivate var margin: CGFloat = 0
    // pageControl的样式
    var style: PageControlStyle = .original

    // 初始化方法
    convenience init(frame: CGRect, style: PageControlStyle) {
        self.init(frame: frame)
        self.tag = -999     // 避免后面遍历tag混乱
        backgroundColor = UIColor.clear
        self.style = style
    }

    fileprivate func layoutPages() {
        if numberOfPages <= 0 { return }
        // 计算出间距(number样式无用)
        margin = (self.frame.width - normalSize.width * CGFloat(numberOfPages))/(CGFloat(numberOfPages) + 1)
        switch style {
        case .original, .square, .ring:
            layoutOrgPages()
        case .bigSmall:
            layoutBigSmallPages()
        case .number:
            layoutNumberPages()
        }
    }

    // 布局默认样式 ring样式 square样式
    fileprivate func layoutOrgPages() {
        let y: CGFloat = (self.frame.height - normalSize.height)*0.5
        for i in 0..<numberOfPages {
            let point = UIView(frame: CGRect(x: CGFloat(i) * (margin + normalSize.width) + margin, y: y, width: normalSize.width, height: normalSize.height))
            point.tag = i
            point.backgroundColor = i == currentPage ? currentColor : normorlColor
            if style == .original {
                point.layer.cornerRadius = normalSize.height * 0.5
                point.layer.masksToBounds = true
            }
            if style == .ring {
                if i != currentPage {
                    point.backgroundColor = UIColor.clear
                } else {
                    point.backgroundColor = currentColor
                }
                point.layer.cornerRadius = normalSize.height * 0.5
                point.layer.borderWidth = 1.0
                point.layer.borderColor = normorlColor.cgColor
                point.layer.masksToBounds = true
            }
            if style == .square {
                point.layer.cornerRadius = 2
            }
            self.addSubview(point)
        }
    }

    // 布局bigSmall样式
    fileprivate func layoutBigSmallPages() {
        let y1: CGFloat = (self.frame.height - normalSize.height)*0.5
        let y2: CGFloat = (self.frame.height - currentSize.height)*0.5
        for i in 0..<numberOfPages {
            let point = UIView(frame: CGRect(x: CGFloat(i) * (margin + normalSize.width) + margin, y: i == currentPage ? y2 : y1, width: i == currentPage ? currentSize.width : normalSize.width, height: i == currentPage ? currentSize.height : normalSize.height))
            point.tag = i
            point.backgroundColor = i == currentPage ? currentColor : normorlColor
            point.layer.cornerRadius = i == currentPage ? currentSize.height * 0.5 : normalSize.height * 0.5
            point.layer.masksToBounds = true
            self.addSubview(point)
        }
    }

    // 布局number样式
    fileprivate func layoutNumberPages() {
        let curLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width*0.5, height: self.frame.height))
        curLabel.tag = curLabelTag
        curLabel.text = "\(currentPage + 1) "
        curLabel.textColor = currentColor
        curLabel.textAlignment = .right
        curLabel.font = UIFont.systemFont(ofSize: currentFont)
        let totalLabel = UILabel(frame: CGRect(x: self.frame.width*0.5, y: 0, width: self.frame.width*0.5, height: self.frame.height))
        totalLabel.textColor = normorlColor
        totalLabel.textAlignment = .left
        totalLabel.text = " / \(numberOfPages)"
        totalLabel.font = UIFont.systemFont(ofSize: normalFont)
        self.addSubview(curLabel)
        self.addSubview(totalLabel)
    }

    // 页码切换
    fileprivate func setPage() {
        if self.subviews.isEmpty { return }
        // 索引容错
        if currentPage > numberOfPages, currentPage < 0 { return }
        switch style {
        case .original, .bigSmall, .square :
            for view in self.subviews {
                view.backgroundColor = normorlColor
                if style == .bigSmall {
                    view.bounds = CGRect(x: 0, y: 0, width: normalSize.width, height: normalSize.height)
                    view.layer.cornerRadius = normalSize.width * 0.5
                    view.layer.masksToBounds = true
                }
            }
            let curView = self.viewWithTag(currentPage)!
            curView.backgroundColor = currentColor
            if style == .bigSmall {
                curView.bounds = CGRect(x: 0, y: 0, width: currentSize.width, height: currentSize.height)
                curView.layer.cornerRadius = currentSize.width * 0.5
                curView.layer.masksToBounds = true
            }
        case .ring:
            for view in self.subviews {
                view.backgroundColor = UIColor.clear
            }
            let curView = self.viewWithTag(currentPage)!
            curView.backgroundColor = currentColor
        case .number:
            if let label = self.viewWithTag(curLabelTag) as? UILabel {
                label.text = "\(currentPage + 1) "
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clear
        // 避免重复创建子控件
        if self.subviews.isEmpty {
            layoutPages()
        }
    }
}
