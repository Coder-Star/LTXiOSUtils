//
//  ImagePickGridView.swift
//  LTXiOSUtils
//  图片选取方格视图，可用于上传图片
//  Created by 李天星 on 2020/3/16.
//

import Foundation

open class ImagePickGridView: UIView {

    // MARK: - 共有属性

    /// 列数
    public var colCount: Int = 4 {
        didSet {
            
        }
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

    public override init(frame: CGRect) {
        super.init(frame: frame)
//        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
//        setupView()
    }

//    private func setupView() {
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: itemHeight * rowCount.cgFloatValue), collectionViewLayout: layout)
//        collectionView?.register(DefaultGridMenuCell.self, forCellWithReuseIdentifier: DefaultGridMenuCell.description())
//        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "emptyCell")
//        collectionView?.dataSource = self
//        collectionView?.delegate = self
//        collectionView?.backgroundColor = .clear
//        collectionView?.showsVerticalScrollIndicator = false
//        collectionView?.showsHorizontalScrollIndicator = false
//        self.addSubview(collectionView!)
//    }
}

//extension ImagePickGridView: UICollectionViewDataSource {
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//}
//
//extension ImagePickGridView: UICollectionViewDelegate {
//
//}
