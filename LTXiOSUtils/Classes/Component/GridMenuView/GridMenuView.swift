//
//  GridMenuView.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/1/12.
//

import Foundation
import UIKit

/// GridMenuView代理
@objc public protocol GridMenuViewItemDelegate {
    /// 点击事件
    /// - Parameters:
    ///   - gridMenuView: GridMenuViewItemDelegate
    ///   - index: 点击索引
    @objc optional func gridMenuView(_ gridMenuView: GridMenuView, selectedItemAt index: Int)
}

public class GridMenuView: UIView {
    // MARK: - 公开属性
    public weak var delegate:GridMenuViewItemDelegate?
    public var heightInfo: CGFloat {
        return viewHeight
    }

    // MARK: - 私有属性
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0 //最小行间距
        layout.minimumInteritemSpacing = 0 //最小左右间距
        return layout
    }()

    private var collectionView: UICollectionView?
    private lazy var pageControl: PageControl = {
        let pageControl = PageControl(frame: CGRect.zero)
        pageControl.style = .ring
        pageControl.currentColor = .blue
        pageControl.normorlColor = .lightGray
        pageControl.normalSize = CGSize(width: 15, height: 5)
        return pageControl
    }()

    /// 行
    private var rowCount: Int = 0
    /// 列
    private var colCount: Int = 0
    private var menu: [GridMenuItem] = [GridMenuItem]()
    private var viewWidth: CGFloat = 0
    private var viewHeight: CGFloat = 0

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public init(width: CGFloat, row: Int, col: Int, menu: [GridMenuItem]) {
        self.init()
        self.viewWidth = width
        self.colCount = col
        self.rowCount = min(row,Int(ceil(Float(menu.count)/Float((colCount)))))
        self.menu = menu
        initView()
    }

    private func initView() {
        let itemWidth = viewWidth / colCount.cgFloatValue
        let itemHeight = itemWidth
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: itemHeight * rowCount.cgFloatValue), collectionViewLayout: layout)
        collectionView?.register(DefaultGridMenuCell.self, forCellWithReuseIdentifier: DefaultGridMenuCell.reuseID)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "emptyCell")
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor.white.adapt()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView!)
        let pageControlCount = Int(ceil(Float(menu.count)/Float((rowCount*colCount))))
        if pageControlCount <= 1 {
            viewHeight = collectionView!.frame.height
        } else {
            pageControl.numberOfPages = pageControlCount
            let pageControlWidth = pageControl.normalSize.width * pageControlCount.cgFloatValue + ((pageControlCount - 1) * 5).cgFloatValue
            pageControl.frame = CGRect(x: (viewWidth - pageControlWidth) / 2, y: collectionView!.frame.height + 5, width: pageControlWidth, height: 10)
            self.addSubview(pageControl)
            viewHeight = collectionView!.frame.height + 20
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 公开方法
public extension GridMenuView {
    /// 刷新
    func reloadData() {
        collectionView?.reloadData()
    }

    /// 更新角标
    /// 适用于红点以及数字样式
    /// - Parameters:
    ///   - code: 模块编码
    ///   - number: 数字
    func updateMark(code: String, number: Int) {
        if let index = menu.compactMap({$0.code}).firstIndex(of: code) {
            switch menu[index].markType {
            case .point:
                menu[index].markType = .point(isShow: number > 0)
            case .number:
                menu[index].markType = .number(number:number)
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
    func updateMark(code: String, isShow: Bool) {
        if let index = menu.compactMap({$0.code}).firstIndex(of: code) {
            menu[index].markType = .point(isShow: isShow)
            reloadData()
        }
    }

    /// 更新角标
    /// 适用于文本样式
    /// - Parameters:
    ///   - code: 模块编码
    ///   - text: 文本内容
    func updateMark(code: String, text: String) {
        if let index = menu.compactMap({$0.code}).firstIndex(of: code) {
            menu[index].markType = .text(text: text)
            reloadData()
        }
    }

}

extension GridMenuView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(ceil(Float(menu.count)/Float((rowCount*colCount)))) * (rowCount*colCount)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = convertDirectionCount(index: indexPath.item)
        if index < menu.count {
            let cell: DefaultGridMenuCell? = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultGridMenuCell.reuseID, for: indexPath) as? DefaultGridMenuCell
            let model = menu[convertDirectionCount(index: indexPath.item)]
            cell?.markType = model.markType
            cell?.text = model.title
            if let imageView = model.imageView {
                cell?.imageView = imageView
            } else {
                cell?.imageView.image = model.image
            }
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
            let index = Int(view.contentOffset.x / self.bounds.width)
            pageControl.currentPage = index
        }

    }
}

extension GridMenuView {
    func convertDirectionCount(index: Int) -> Int {
        let tempH = index / (colCount * rowCount)
        let tempL = index % (colCount * rowCount)
        let result = tempL - (tempL / rowCount) * (rowCount - 1) + tempL % rowCount * (colCount - 1) + tempH * (colCount * rowCount)
        return result
    }
}
