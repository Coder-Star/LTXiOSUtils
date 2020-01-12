//
//  GridMenuModel.swift
//  LTXiOSUtils
//  格式菜单子项实体
//  Created by 李天星 on 2020/1/11.
//

import Foundation

/// 格子菜单实体
public struct GridMenuItem {
    /// 编码
    public var code: String
    /// 标题
    public var title: String
    /// 图片
    public var image: UIImage?
    /// 图片View，方便使用远程图片，如果不为nil，优先使用这个
    public var imageView: UIImageView?
    /// 角标类型，默认为无
    public var markType: CornerMarkType = .none

    /// 构造函数
    /// - Parameters:
    ///   - code: 编码
    ///   - title: 标题
    public init(code: String, title: String) {
        self.code = code
        self.title = title
    }

    /// 构造函数
    /// - Parameters:
    ///   - code: 编码
    ///   - title: 标题
    ///   - image: 图标
    public init(code: String, title: String, image: UIImage?) {
        self.code = code
        self.title = title
        self.image = image
    }

    /// 构造函数
    /// - Parameters:
    ///   - code: 编码
    ///   - title: 标题
    ///   - image: 图标
    public init(code: String, title: String, image: UIImage?, markType: CornerMarkType) {
        self.code = code
        self.title = title
        self.image = image
        self.markType = markType
    }

    /// 构造函数
    /// - Parameters:
    ///   - code: 编码
    ///   - title: 标题
    ///   - imageView: 图标View
    public init(code: String, title: String, imageView: UIImageView) {
        self.code = code
        self.title = title
        self.imageView = imageView
    }

    /// /// 构造函数
    ///  - Parameters:
    ///    - code: 编码
    ///    - title: 标题
    ///    - imageView: 图标View
    ///    - markType: 角标类型
    public init(code: String, title: String, imageView: UIImageView, markType: CornerMarkType) {
        self.code = code
        self.title = title
        self.imageView = imageView
        self.markType = markType
    }
}
