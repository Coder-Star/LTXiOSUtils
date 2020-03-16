//
//  TreeNode.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/2/1.
//

import Foundation

/// 节点状态
public enum TreeNodeCheckState {
    /// 未选中
    case uncheckd
    /// 选中
    case checked
    /// 半选中，当子节点有选中但未全部选中时
    case halfChecked
}

/// 排序类型
public enum TreeNodeSordType {
    /// 正序
    case asc
    /// 倒序
    case desc
}

/// 节点实体
public class TreeNode: NSObject {
    /// 名称，用于显示
    public var name: String
    /// 搜索名称，用于多条件搜索
    public var filterName: [String]
    /// ID
    public var ID: String
    /// parentID
    public var parentID: String
    /// 排序号
    public var sordCode: Int
    /// 数据类型
    public var type: String
    /// 是否顶级父节点
     public var isTop: Bool
    /// 是否叶子节点
    public var isLeaf: Bool
    /// 原始数据
    public var data: Any

    var level: Int = 0
    var isExpand: Bool = false
    var checkState: TreeNodeCheckState = .uncheckd
    var parentNode: TreeNode?
    var childNodes: [TreeNode] = [TreeNode]()

    public init(name: String, filterName: [String], ID: String, parentID: String, sordCode: Int, type: String, isTop: Bool, isLeaf: Bool, data: Any) {
        self.name = name
        self.filterName = filterName
        self.ID = ID
        self.parentID = parentID
        self.sordCode = sordCode
        self.type = type
        self.isTop = isTop
        self.isLeaf = isLeaf
        self.data = data
    }

}
