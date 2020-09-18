//
//  TreeData.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/2/2.
//

import Foundation

/// 树形图数据
public class TreeData {

    /// 排序类型
    private var sordType: TreeNodeSordType = .asc
    /// 节点列表
    private var treeNodes = [TreeNode]()
    /// 节点字典
    private var nodesMap = [String: TreeNode]()
    /// 顶级父节点
    private var topNodes = [TreeNode]()
    /// 数据层次最大等级
    private var maxLevel: Int = 0
    /// 展开的最大等级
    private var expandLevel: Int = 0
    /// 显示的Node
    public private(set) var showNodes = [TreeNode]()

    /// 遍历构造函数
    /// - Parameter treeNodes: 节点列表
    public convenience init(treeNodes: [TreeNode]) {
        self.init(treeNodes: treeNodes, expandLevel: 0, sordType: .asc)
    }

    /// 构造函数
    /// - Parameters:
    ///   - treeNodes: 节点列表
    ///   - expandLevel: 展开层级
    ///   - sordType: 排序类型
    public init(treeNodes: [TreeNode], expandLevel: Int, sordType: TreeNodeSordType) {
        /// 去重
        if treeNodes.count != Set(treeNodes).count {
            self.treeNodes = Array(Set(treeNodes))
        } else {
            self.treeNodes = treeNodes
        }
        self.sordType = sordType
        self.expandLevel = expandLevel

        setupNodesMap()
        setupTopNodes()
        setupNodesLevel()
        setupShowNodes()
    }
}

// MARK: - 数据初始化
extension TreeData {

    /// 建立节点Map
    private func setupNodesMap() {
        for node in treeNodes {
            nodesMap[node.ID] = node
        }
    }

    /// 设置顶级父节点，建立层级关系
    private func setupTopNodes() {
        treeNodes = Array(nodesMap.values)
        var tempTopNodes = [TreeNode]()
        for node in treeNodes {
            node.isExpand = false
            /// 获取顶级父节点
            if node.isTop {
                tempTopNodes.append(node)
            }
            /// 建立层级关系
            if let parentNode = nodesMap[node.parentID] {
                node.parentNode = parentNode
                if !parentNode.childNodes.contains(node) {
                    parentNode.childNodes.append(node)
                }
            }
        }

        // 顶级节点排序
        topNodes = sortNode(nodes: tempTopNodes)
        /// 所有节点排序
        for node in treeNodes {
            node.childNodes = sortNode(nodes: node.childNodes)
        }

    }

    /// 设置节点等级以及层次关系最大等级
    private func setupNodesLevel() {
        for node in treeNodes {
            var level = 0
            var parentNode = node.parentNode

            while parentNode != nil {
                level += 1
                parentNode = parentNode?.parentNode
            }
            node.level = level
            maxLevel = max(maxLevel, level)
        }
    }

    /// 设置展示的节点
    private func setupShowNodes() {
        expandLevel = max(expandLevel, 0)
        expandLevel = min(maxLevel, expandLevel)
        var tempNodes = [TreeNode]()
        for node in topNodes {
            let addNodes = self.addNode(node: node, showNodes: [TreeNode]())
            tempNodes.append(contentsOf: addNodes)
        }
        showNodes = tempNodes
    }

    /// 递归拼接展示的节点
    /// 数据初始化使用
    /// - Parameters:
    ///   - node: 节点
    ///   - showNodes: 展示的节点
    private func addNode(node: TreeNode, showNodes: [TreeNode]) -> [TreeNode] {
        var nodes = showNodes
        if node.level <= expandLevel {
            nodes.append(node)
            node.isExpand = node.level != expandLevel
        }
        node.childNodes = sortNode(nodes: node.childNodes)
        for childNode in node.childNodes {
            nodes = self.addNode(node: childNode, showNodes: nodes)
        }
        return nodes
    }

    /// 对节点进行排序
    private func sortNode(nodes: [TreeNode]) -> [TreeNode] {
        return nodes.sorted { (obj1, obj2) -> Bool in
            switch sordType {
            case .asc:
                return obj1.sordCode < obj2.sordCode
            case .desc:
                return obj1.sordCode > obj2.sordCode
            }
        }
    }
}

// MARK: - 节点展开、收起
extension TreeData {

    /// 展开节点
    /// - Parameter node: 节点
    func expandNode(node: TreeNode) -> Int {
        return expandNode(node: node, isExpand: !node.isExpand)
    }

    /// 展开、收起节点
    /// - Parameters:
    ///   - node: 节点
    ///   - isExpand: 是否展开
    func expandNode(node: TreeNode, isExpand: Bool) -> Int {
        if node.isExpand == isExpand {
            return 0
        }
        node.isExpand = isExpand
        var nodes = [TreeNode]()
        if isExpand {
            for childNode in node.childNodes {
                nodes = addNode(node: childNode, nodes: nodes)
            }
            if let index = showNodes.firstIndex(of: node) {
                self.showNodes.insert(contentsOf: nodes, at: index + 1)
            }
        } else {
            for showNode in showNodes {
                var isParent = false
                var parent = showNode.parentNode
                while parent != nil {
                    if parent == node {
                        isParent = true
                        break
                    }
                    parent = parent?.parentNode
                }
                if isParent {
                    nodes.append(showNode)
                }
            }
            self.showNodes = self.showNodes.filter { !nodes.contains($0) }
        }
        return nodes.count
    }

    /// 拼接节点
    /// 展开、收起节点时使用
    /// - Parameters:
    ///   - node: 节点
    ///   - nodes: 节点数据
    private func addNode(node: TreeNode, nodes: [TreeNode]) -> [TreeNode] {
        var tempNodes = nodes
        tempNodes.append(node)
        if node.isExpand {
            node.childNodes = sortNode(nodes: node.childNodes)
            for childNode in node.childNodes {
                tempNodes = self.addNode(node: childNode, nodes: tempNodes)
            }
        }
        return tempNodes
    }

    /// 展开、折叠指定级数
    /// - Parameters:
    ///   - expandLevel: 指定级数
    ///   - noExpandCompleted: 折叠闭包
    ///   - expandCompleted: 展开闭包
    func expandNodeWithLevel(expandLevel: Int, noExpandCompleted: (_ array: [TreeNode]) -> Void, expandCompleted: (_ array: [TreeNode]) -> Void) {
        var level = max(expandLevel, 0)
        level = min(expandLevel, maxLevel)

        /// 一级一级折叠
        for indexLevel in (expandLevel...maxLevel).reversed() {
            var nodes = [TreeNode]()
            for node in showNodes where node.isExpand && node.level == indexLevel {
                nodes.append(node)
            }
            if nodes.count > 0 {
                noExpandCompleted(nodes)
            }
        }

        /// 一级一级展开
        for indexLevel in 0..<level {
            var nodes = [TreeNode]()
            for node in showNodes where !node.isExpand && node.level == indexLevel {
                nodes.append(node)
            }
            if nodes.count > 0 {
                expandCompleted(nodes)
            }
        }
    }
}

// MARK: - 勾选
extension TreeData {

    /// 勾选、取消勾选所有节点
    /// - Parameter isCheck: 是否勾选
    func checkAllNode(isCheck: Bool) {
        for node in showNodes where  node.level == 0 {
            checkNode(node: node, isCheck: isCheck, isChildNodesCheck: true)
        }
    }

    func checkNode(node: TreeNode, isChildNodesCheck: Bool) {
        checkNode(node: node, isCheck: node.checkState != .checked, isChildNodesCheck: isChildNodesCheck)
    }

    /// 勾选节点
    /// - Parameters:
    ///   - node: 节点
    ///   - isCheck: 是否勾选节点
    ///   - isChildNodesCheck: 是否子节点也勾选
    func checkNode(node: TreeNode, isCheck: Bool, isChildNodesCheck: Bool) {
        if node.checkState == .checked && isCheck {
            return
        }
        if node.checkState == .uncheckd && !isCheck {
            return
        }
        checkChildNodes(node: node, isCheck: isCheck, isChildNodesCheck: isChildNodesCheck)
        refreshParentNode(node: node, isChildNodesCheck: isChildNodesCheck)
    }

    func checkChildNodes(node: TreeNode, isCheck: Bool, isChildNodesCheck: Bool) {
        node.checkState = isCheck ? TreeNodeCheckState.checked : TreeNodeCheckState.uncheckd
        for childNode in node.childNodes {
            if isChildNodesCheck {
                self.checkChildNodes(node: childNode, isCheck: isCheck, isChildNodesCheck: isChildNodesCheck)
            } else {
                self.checkChildNodes(node: childNode, isCheck: false, isChildNodesCheck: isChildNodesCheck)
            }
        }
    }

    func refreshParentNode(node: TreeNode, isChildNodesCheck: Bool) {
        if isChildNodesCheck {
            var uncheckdNum = 0
            var checkdNum = 0
            if let parentNode = node.parentNode {
                for childNode in parentNode.childNodes {
                    switch childNode.checkState {
                    case .uncheckd:
                        uncheckdNum += 1
                    case .checked:
                        checkdNum += 1
                    case .halfChecked:
                        break
                    }
                }
                if uncheckdNum == parentNode.childNodes.count {
                    node.parentNode?.checkState = .uncheckd
                } else if checkdNum == parentNode.childNodes.count {
                    node.parentNode?.checkState = .checked
                } else {
                    node.parentNode?.checkState = .halfChecked
                }
            }
        } else {
            node.parentNode?.checkState = .uncheckd
        }
        if let parentNode = node.parentNode {
            refreshParentNode(node: parentNode, isChildNodesCheck: isChildNodesCheck)
        }
    }
}

// MARK: - 筛选,过滤
extension TreeData {

    func filterFieldAndType(filed: String, type: String, isChildNodeCheck: Bool) {
        setupTopNodes()
        if !filed.isEmpty {
            /// 将不符合条件的节点去除
            for node in treeNodes {
                let childNodes = getAllChildNodesByNode(node: node)
                if isContain(nodes: childNodes, filed: filed, type: type) {
                    node.isExpand = true
                    continue
                }

                if isContain(nodes: [node], filed: filed, type: type) {
                    continue
                }
                let parentNodes = getAllParentNodesByNode(node: node)
                if isContain(nodes: parentNodes, filed: filed, type: type) {
                    continue
                }
                if let index = node.parentNode?.childNodes.firstIndex(of: node) {
                    node.parentNode?.childNodes.remove(at: index)
                }
                if let index = topNodes.firstIndex(of: node) {
                    topNodes.remove(at: index)
                }
                for childNode in childNodes {
                    if let index = childNode.parentNode?.childNodes.firstIndex(of: node) {
                        childNode.parentNode?.childNodes.remove(at: index)
                    }
                }
            }

            /// 生成展示的节点数组
            var tempShowNodes = [TreeNode]()
            for node in topNodes {
                tempShowNodes = addNode(node: node, filterNodes: tempShowNodes)
            }
            self.showNodes = tempShowNodes
        } else {
            setupShowNodes()
        }

        for node in treeNodes {
            refreshParentNode(node: node, isChildNodesCheck: isChildNodeCheck)
        }
    }
    /// 拼接节点
    /// 用于筛选过滤使用
    /// - Parameters:
    ///   - node: 节点
    ///   - childNodes: 节点集合
    private func addNode(node: TreeNode, filterNodes: [TreeNode]) -> [TreeNode] {
        var tempNodes = filterNodes
        tempNodes.append(node)
        if node.childNodes.count > 0 {
            node.childNodes = sortNode(nodes: node.childNodes)
            for childNode in node.childNodes where node.isExpand {
                tempNodes = addNode(node: childNode, filterNodes: tempNodes)
            }
        }
        return tempNodes
    }

    /// 判断节点是否满足搜索条件
    /// - Parameters:
    ///   - nodes: 节点
    ///   - filed: 搜索字段
    ///   - type: 指定节点类型,为空时表示不指定节点类型
    private func isContain(nodes: [TreeNode], filed: String, type: String) -> Bool {
        var isContain = false
        for node in nodes {
            if type.isEmpty {
                if isFilterNameContain(filterName: node.filterName, filed: filed) {
                    isContain = true
                    break
                }
            } else {
                if isFilterNameContain(filterName: node.filterName, filed: filed), node.type == type {
                    isContain = true
                    break
                }
            }
        }
        return isContain
    }

    private func isFilterNameContain(filterName: [String], filed: String) -> Bool {
        var result = false
        for item in filterName where item.contains(filed) {
            result = true
            break
        }
        return result
    }
}

// MARK: - 获取数据
extension TreeData {
    /// 根据节点ID获取指定节点
    /// - Parameter ID: 节点ID
    public func getNodeByID(ID: String) -> TreeNode? {
        return nodesMap[ID]
    }

    /// 所有勾选的节点
    public var allCheckNodes: [TreeNode] {
        var nodes = [TreeNode]()
        /// 从顶级节点进行遍历，防止多次计算
        for node in showNodes where node.level == 0 {
            nodes = getCheckNode(node: node, nodes: nodes)
        }
        return nodes
    }

    private func getCheckNode(node: TreeNode, nodes: [TreeNode]) -> [TreeNode] {
        var tempNodes = nodes
        if node.checkState == .checked {
            tempNodes.append(node)
        }
        for childNode in node.childNodes {
           tempNodes = getCheckNode(node: childNode, nodes: tempNodes)
        }
        return tempNodes
    }

    /// 获取指定节点的所有子节点
    /// - Parameter node: 指定子节点
    public func getAllChildNodesByNode(node: TreeNode) -> [TreeNode] {
        var childNodes = [TreeNode]()
        childNodes = addNode(node: node, childNodes: childNodes)
        return childNodes
    }

    /// 拼接节点
    /// 用于获取指定节点所有子节点
    /// - Parameters:
    ///   - node: 节点
    ///   - childNodes: 节点集合
    private func addNode(node: TreeNode, childNodes: [TreeNode]) -> [TreeNode] {
        var tempNodes = childNodes
        node.childNodes = sortNode(nodes: node.childNodes)
        for childNode in node.childNodes {
            tempNodes.append(childNode)
            tempNodes = self.addNode(node: childNode, childNodes: tempNodes)
        }
        return tempNodes
    }

    /// 获取指定节点的所有父节点
    /// - Parameter node: 指定节点
    public func getAllParentNodesByNode(node: TreeNode) -> [TreeNode] {
        var parentNodes = [TreeNode]()
        var parentNode = node.parentNode
        while parentNode != nil {
            parentNodes.append(parentNode!)
            parentNode = parentNode?.parentNode
        }
        return parentNodes
    }
}
