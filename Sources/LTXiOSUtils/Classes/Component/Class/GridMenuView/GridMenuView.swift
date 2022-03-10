//
//  GridMenuView.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2020/1/12.
//

import Foundation
import UIKit

/// 显示模式
public enum GridMenuViewMode {
    /// 横向分页
    case horizontalPage
    /// 横向滚动
    case horizontalScroll
}

/// GridMenuView代理
@objc
public protocol GridMenuViewItemDelegate {
    /// 点击事件
    /// - Parameters:
    ///   - gridMenuView: GridMenuViewItemDelegate
    ///   - index: 点击索引
    @objc
    optional func gridMenuView(_ gridMenuView: GridMenuView, selectedItemAt index: Int)
}

public class GridMenuView: UIView {
    // MARK: - 公开属性

    /// 代理
    public weak var delegate: GridMenuViewItemDelegate?
    /// 布局后GridMenuView高度
    public var heightInfo: CGFloat {
        return viewHeight
    }

    // MARK: - 私有属性

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        /// iOS 10需要人工设置值
        layout.footerReferenceSize = CGSize(width: 0, height: 0.01)
        layout.minimumLineSpacing = 0 // 最小行间距
        layout.minimumInteritemSpacing = 0 // 最小左右间距
        return layout
    }()

    private var collectionView: UICollectionView?
    private lazy var pageControl: PageControl = {
        let pageControl = PageControl(frame: CGRect.zero)
        pageControl.currentColor = UIColor(hexString: "#4296d5")
        pageControl.normorlColor = .lightGray
        return pageControl
    }()

    private lazy var scrollPageControlView: ScrollPageControlView = {
        let scrollPageControlView = ScrollPageControlView()
        return scrollPageControlView
    }()

    /// 行
    private var rowCount: Int = 0
    /// 列
    private var colCount: Int = 0
    /// 菜单
    public private(set) var menu = [GridMenuItem]()
    /// 页面宽度
    private var viewWidth: CGFloat = 0
    /// 页面高度
    private var viewHeight: CGFloat = 0
    /// 模式
    private var mode: GridMenuViewMode = .horizontalPage

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// 便利构造函数
    /// - Parameters:
    ///   - width: 页面宽度
    ///   - row: 行数
    ///   - col: 列数
    ///   - menu: 菜单
    convenience public init(width: CGFloat, row: Int, col: Int, menu: [GridMenuItem]) {
        let pageStyle: PageControlStyle = .square(size: CGSize(width: 15, height: 5))
        self.init(width: width, row: row, col: col, menu: menu, mode: .horizontalPage, pageStyle: pageStyle)
    }

    /// 便利构造函数
    /// - Parameters:
    ///   - width: 页面宽度
    ///   - row: 行数
    ///   - col: 列数
    ///   - menu: 菜单
    ///   - pageStyle: 分页样式
    convenience public init(width: CGFloat, row: Int, col: Int, menu: [GridMenuItem], pageStyle: PageControlStyle) {
        self.init(width: width, row: row, col: col, menu: menu, mode: .horizontalPage, pageStyle: pageStyle)
    }

    /// 便利构造函数
    /// - Parameters:
    ///   - width: 页面宽度
    ///   - row: 行数
    ///   - col: 列数
    ///   - menu: 菜单
    ///   - mode: 模式
    ///   - pageStyle: 分页样式
    convenience public init(width: CGFloat, row: Int, col: Int, menu: [GridMenuItem], mode: GridMenuViewMode, pageStyle: PageControlStyle) {
        self.init()
        self.menu = menu
        self.mode = mode
        pageControl.style = pageStyle
        viewWidth = width
        colCount = col
        rowCount = min(row, Int(ceil(Float(menu.count) / Float(colCount))))
        initView()
    }

    private func initView() {
        let itemWidth = viewWidth / CGFloat(colCount)
        let itemHeight = itemWidth
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: itemHeight * CGFloat(rowCount)), collectionViewLayout: layout)
        collectionView?.register(DefaultGridMenuCell.self, forCellWithReuseIdentifier: DefaultGridMenuCell.description())
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "emptyCell")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = .clear
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        addSubview(collectionView!)
        setModeStyle()
    }

    private func setModeStyle() {
        switch mode {
        case .horizontalPage:
            collectionView?.isPagingEnabled = true
            let pageControlCount = Int(ceil(Float(menu.count) / Float(rowCount * colCount)))
            if pageControlCount <= 1 {
                viewHeight = collectionView!.frame.height
            } else {
                pageControl.numberOfPages = pageControlCount
                pageControl.frame = CGRect(x: (viewWidth - pageControl.intrinsicContentSize.width) / 2, y: collectionView!.frame.height + 5, width: pageControl.intrinsicContentSize.width, height: pageControl.intrinsicContentSize.height)
                addSubview(pageControl)
                viewHeight = collectionView!.frame.height + pageControl.intrinsicContentSize.height + 10
            }
        case .horizontalScroll:
            collectionView?.isPagingEnabled = false
            let realColCount = Int(ceil(Float(menu.count) / Float(rowCount)))
            if realColCount <= colCount {
                viewHeight = collectionView!.frame.height
            } else {
                let scrollPageControlViewWidth: CGFloat = 50
                scrollPageControlView.frame = CGRect(x: (viewWidth - scrollPageControlViewWidth) / 2, y: collectionView!.frame.height + 5, width: scrollPageControlViewWidth, height: 3)
                addSubview(scrollPageControlView)
                scrollPageControlView.currentIndicatorWidth = CGFloat(colCount) / CGFloat(realColCount) * scrollPageControlViewWidth
                viewHeight = collectionView!.frame.height + scrollPageControlView.frame.height + 10
            }
        }
    }

    private func convertDirectionCount(index: Int) -> Int {
        switch mode {
        case .horizontalPage:
            let tempH = index / (colCount * rowCount)
            let tempL = index % (colCount * rowCount)
            let result = tempL - (tempL / rowCount) * (rowCount - 1) + tempL % rowCount * (colCount - 1) + tempH * (colCount * rowCount)
            return result
        case .horizontalScroll:
            let scrollColCount = menu.count % rowCount == 0 ? menu.count / rowCount : (menu.count / rowCount) + 1
            let tempH = index / (scrollColCount * rowCount)
            let tempL = index % (scrollColCount * rowCount)
            let result = tempL - (tempL / rowCount) * (rowCount - 1) + tempL % rowCount * (scrollColCount - 1) + tempH * (scrollColCount * rowCount)
            return result
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 公开属性、方法

extension GridMenuView {
    /// 分页控件当前颜色
    public var pageControlCurrentColor: UIColor {
        set {
            switch mode {
            case .horizontalPage:
                pageControl.currentColor = newValue
            case .horizontalScroll:
                scrollPageControlView.currentIndicatorColor = newValue
            }
        }
        get {
            switch mode {
            case .horizontalPage:
                return pageControl.currentColor
            case .horizontalScroll:
                return scrollPageControlView.currentIndicatorColor
            }
        }
    }

    /// 分页控件正常颜色
    public var pageControlNormorlColor: UIColor {
        set {
            switch mode {
            case .horizontalPage:
                pageControl.normorlColor = newValue
            case .horizontalScroll:
                scrollPageControlView.backgroundColor = newValue
            }
        }
        get {
            switch mode {
            case .horizontalPage:
                return pageControl.normorlColor
            case .horizontalScroll:
                return scrollPageControlView.backgroundColor ?? UIColor(hexString: "#eeeeee")
            }
        }
    }

    /// 横向滚动滑动宽度
    public var currentIndicatorWidth: CGFloat {
        set {
            scrollPageControlView.currentIndicatorWidth = newValue
        }
        get {
            return scrollPageControlView.currentIndicatorWidth
        }
    }

    /// 刷新
    public func reloadData() {
        collectionView?.reloadData()
    }

    /// 更新角标
    /// 适用于红点以及数字样式
    /// - Parameters:
    ///   - code: 模块编码
    ///   - number: 数字
    public func updateMark(code: String, number: Int) {
        if let index = menu.compactMap({ $0.code }).firstIndex(of: code) {
            switch menu[index].markType {
            case .point:
                menu[index].markType = .point(isShow: number > 0)
            case .number:
                menu[index].markType = .number(number: number)
            default:
                break
            }
            reloadData()
        }
    }

    /// 更新角标
    /// 适用于红点样式
    /// - Parameters:
    ///   - code: 模块编码
    ///   - number: 数字
    public func updateMark(code: String, isShow: Bool) {
        if let index = menu.compactMap({ $0.code }).firstIndex(of: code) {
            menu[index].markType = .point(isShow: isShow)
            reloadData()
        }
    }

    /// 更新角标
    /// 适用于文本样式
    /// - Parameters:
    ///   - code: 模块编码
    ///   - text: 文本内容
    public func updateMark(code: String, text: String) {
        if let index = menu.compactMap({ $0.code }).firstIndex(of: code) {
            menu[index].markType = .text(text: text)
            reloadData()
        }
    }
}

extension GridMenuView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mode {
        case .horizontalPage:
            return Int(ceil(Float(menu.count) / Float(rowCount * colCount))) * (rowCount * colCount)
        case .horizontalScroll:
            return menu.count % rowCount == 0 ? menu.count : (menu.count / rowCount + 1) * rowCount
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = convertDirectionCount(index: indexPath.item)
        if index < menu.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultGridMenuCell.description(), for: indexPath) as? DefaultGridMenuCell
            let model = menu[convertDirectionCount(index: indexPath.item)]
            cell?.markType = model.markType
            cell?.text = model.title
            cell?.imageView.image = model.image
            return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            return cell
        }
    }
}

extension GridMenuView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = convertDirectionCount(index: indexPath.item)
        if index < menu.count {
            delegate?.gridMenuView?(self, selectedItemAt: index)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let view = collectionView {
            if mode == .horizontalPage {
                let index = Int(view.contentOffset.x / bounds.width)
                pageControl.currentPage = index
            }
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let view = collectionView {
            if mode == .horizontalScroll {
                var offsetX = view.contentOffset.x
                if offsetX < 0 {
                    offsetX = 0
                } else if offsetX > view.contentSize.width - view.frame.width {
                    offsetX = view.contentSize.width - view.frame.width
                }
                scrollPageControlView.progrss = offsetX * scrollPageControlView.offsetWidth / (view.contentSize.width - view.frame.width)
            }
        }
    }
}
