//
//  GridMenuModel.swift
//  LTXiOSUtils
//  格式菜单子项实体
//  Created by CoderStar on 2020/1/11.
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

    /// /// 构造函数
    ///  - Parameters:
    ///    - code: 编码
    ///    - title: 标题
    ///    - markType: 角标类型
    public init(code: String, title: String, markType: CornerMarkType) {
        self.code = code
        self.title = title
        self.markType = markType
    }
}
