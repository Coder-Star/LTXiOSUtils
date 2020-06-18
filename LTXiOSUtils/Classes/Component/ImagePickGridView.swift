//
//  ImagePickGridView.swift
//  LTXiOSUtils
//  图片选取方格视图，可用于上传图片
//  Created by 李天星 on 2020/3/16.
//

import Foundation
import UIKit

/// 图片选取View代理
@objc
public protocol ImagePickGridViewDelegte {
    /// 添加图片
    /// - Parameter imagePickGridView: imagePickGridView
    @objc
    optional func addImage(imagePickGridView: ImagePickGridView)

    /// 点击图片
    /// - Parameters:
    ///   - imagePickGridView: imagePickGridView
    ///   - index: 点击索引
    @objc
    optional func clickImage(imagePickGridView: ImagePickGridView, index: Int)

    /// frame变化
    /// - Parameter imagePickGridView: imagePickGridView
    @objc
    optional func frameChange(imagePickGridView: ImagePickGridView)

    ///
    /// - Parameters:
    ///   - imagePickGridView: imagePickGridView
    ///   - count: 当前图片数量
    @objc
    optional func imageCountChange(imagePickGridView: ImagePickGridView, count: Int)

}

/// 图片选取View
open class ImagePickGridView: UIView {

    // MARK: - 共有属性

    /// 列数
    public var colCount: Int = 4 {
        didSet {
            setNeedsLayout()
        }
    }

    /// 图片数据
    public private(set) var imageList = [PickImageModel]() {
        didSet {
            delegte?.imageCountChange?(imagePickGridView: self, count: imageList.count)
        }
    }

    /// 是否需要图片添加按钮
    public var isNeedAddButton: Bool = true
    /// 是否需要图片删除按钮
    public var isNeedDeleteButton: Bool = true
    /// 图片最大数量
    /// 小于等于0表示没有最大限制
    public var maxImageCount: Int = 9
    /// 代理
    public weak var delegte: ImagePickGridViewDelegte?

    // MARK: - 私有属性
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0 //最小行间距
        layout.minimumInteritemSpacing = 0 //最小左右间距
        return layout
    }()

    private var collectionView: UICollectionView?
    private var heightConstraint: NSLayoutConstraint?
    private var itemWidth: CGFloat?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        Log.d(self.frame)
        itemWidth = self.frame.width / colCount.tx.cgFloatValue
        if layout.itemSize == .zero {
            layout.itemSize = CGSize(width: itemWidth ?? 0, height: itemWidth ?? 0)
        }
        collectionView?.height = self.frame.height
        collectionView?.width = self.frame.width
        reloadDataAndFrame()
    }

    private func setupView() {
        layout.itemSize = CGSize.zero
        /// 如果设置frame为空，不会走cellForItemAt代理
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: layout)
        collectionView?.register(ImagePickGridViewCell.self, forCellWithReuseIdentifier: ImagePickGridViewCell.description())
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = self.backgroundColor
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView!)
    }

    private func reloadDataAndFrame() {
        let heightInfo = (itemWidth ?? 0) * Int(ceil(Float(showImageCount) / Float((colCount)))).tx.cgFloatValue
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: heightInfo)
            addConstraint(heightConstraint!)
        }
        collectionView?.reloadData()
        if heightInfo != heightConstraint?.constant {
            heightConstraint!.constant = heightInfo
            setNeedsLayout()
            self.superview?.layoutIfNeeded()
            delegte?.frameChange?(imagePickGridView: self)
        }
    }
}

// MARK: - 公有方法
public extension ImagePickGridView {
    /// 删除图片
    /// - Parameter index: 删除图片索引
    func removeImage(index: Int) {
        imageList.remove(at: index)
        reloadDataAndFrame()
    }

    /// 添加图片
    /// - Parameter imageArr: 图片列表
    func addImage(imageArr: [PickImageModel]) {
        for item in imageArr {
            if item.id == nil ||
                (item.id != nil && !imageList.compactMap { $0.id }.contains(item.id!) ) {
                imageList.append(item)
            }
        }

        if maxImageCount > 0, imageList.count > maxImageCount {
            imageList = Array(imageList.prefix(upTo: maxImageCount))
        }
        reloadDataAndFrame()
    }

    /// 剩余可选最大数量
    var canPickResidueMaxCount: Int {
        if maxImageCount <= 0 {
            return -1
        } else {
            let count = maxImageCount - imageList.count
            return count < 0 ? 0 : count
        }
    }
}

// MARK: - 私有方法
private extension ImagePickGridView {
    private var showImageCount: Int {
        if maxImageCount > 0, imageList.count >= maxImageCount {
            return maxImageCount
        } else {
            if isNeedAddButton {
                return imageList.count + 1
            } else {
                return imageList.count
            }
        }
    }
}

// MARK: - 协议
extension ImagePickGridView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showImageCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickGridViewCell.description(), for: indexPath) as? ImagePickGridViewCell
        if indexPath.item < imageList.count {
            cell?.imageView.image = imageList[indexPath.item].image
            cell?.deleteButton.isHidden = !isNeedDeleteButton
            if isNeedDeleteButton {
                cell?.deleteButton.addTapGesture {[weak self] _ in
                    self?.removeImage(index: indexPath.item)
                }
            }
        } else if indexPath.item == imageList.count {
            cell?.imageView.image = "ImagePickGridView_addImage".imageOfLTXiOSUtils()
            cell?.deleteButton.isHidden = true
        }
        return cell!
    }

}

extension ImagePickGridView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Log.d(indexPath.item)
        if indexPath.item < imageList.count {
            self.delegte?.clickImage?(imagePickGridView: self, index: indexPath.item)
        } else if indexPath.item == imageList.count {
            Log.d("点击添加")
            self.delegte?.addImage?(imagePickGridView: self)
        }
    }
}

///文件信息
public class PickImageModel: NSObject {
    /// 图片数据
    public var image: UIImage?
    /// 图片名称
    public var name: String?
    /// 图片尺寸
    public var size: String?
    /// 图片格式
    public var type: String?
    /// id，唯一标志符号
    public var id: String?
    /// 携带数据
    public var data: Any?

    /// 构造函数
    /// - Parameters:
    ///   - image: 图片数据
    public init(image: UIImage?, id: String?, data: Any?) {
        self.image = image
        self.id = id
        self.data = data
    }

    /// 构造函数
    /// - Parameters:
    ///   - image: 图片数据
    ///   - id: id
    public init(image: UIImage?, id: String?) {
        self.image = image
        self.id = id
    }

    /// 构造函数
    /// - Parameters:
    ///   - image: 图片数据
    public init(image: UIImage?) {
        self.image = image
    }

}

public class ImagePickGridViewCell: UICollectionViewCell {

    public static var deleteButtonWidth: CGFloat = 20

    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    public lazy var deleteButton: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = "ImagePickGridView_deleteImage".imageOfLTXiOSUtils()
        return imageView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.addSubview(imageView)
        let margin = ImagePickGridViewCell.deleteButtonWidth / 2
        imageView.frame = CGRect(x: margin,
                                 y: margin,
                                 width: self.frame.width - margin * 2,
                                 height: self.frame.height - margin * 2)

        self.addSubview(deleteButton)
        deleteButton.frame = CGRect(x: self.frame.width - ImagePickGridViewCell.deleteButtonWidth,
                                    y: 0,
                                    width: ImagePickGridViewCell.deleteButtonWidth,
                                    height: ImagePickGridViewCell.deleteButtonWidth)
    }
}
