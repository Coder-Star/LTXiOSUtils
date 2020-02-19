//
//  TreeTableView.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/2/1.
//

import Foundation

/// 协议
@objc
public protocol TreeTableViewDelegate: NSObjectProtocol {
    /// 获取勾选的数据
    /// - Parameter nodes: 节点数组
    func checkNodes(nodes: [TreeNode])

    /// 数据刷新
    /// 如果isNeedRefresh = true，请实现该方法
    @objc
    optional func refreshData()

    /// 搜素之前，对搜索值进行处理，如去除空格等
    /// - Parameter filed: 字段值
    @objc
    optional func beforeSearch(filed: String) -> String
}

public class TreeTableView: UIView {

    // MARK: - 公开属性
    /// 是否单选
    public var isSingleCheck: Bool = true
    /// 是否显示前面箭头
    public var isShowArrow: Bool = true
    /// 是否需要刷新
    public var isNeedRefresh: Bool = true
    /// 是否显示搜索框
    public var isShowSearchBar: Bool = true
    /// 是否实时搜索
    public var isSearchRealTime: Bool = true
    /// 多选时选择父节点时，子节点也被选择，在单选模式下没有意义
    /// 如果子节点被选择，其所有父节点也被勾选
    public var isChildCheck: Bool = false
    /// 指定搜索类型，为空时表示不指定搜索类型
    public var typeForSearch = ""
    /// Cell文字显示样式,默认尾部省略号显示
    public var cellTextStyle: TreeTableViewCellTextStyle = .truncatingTail

    /// 树形数据
    public var treeData: TreeData? {
        didSet {
            tableView.reloadData()
        }
    }

    /// 默认勾选的节点,在单选模式下没有意义
    public var checkNodesID: [String] = [String]() {
        didSet {
            if !isSingleCheck {
                initCheckNodesID()
                if treeData != nil {
                    tableView.reloadData()
                }
            }
        }
    }

    /// 代理
    public weak var delegate: TreeTableViewDelegate?

    /// 搜索框
    public var searchBar: TreeTableViewSearchBar?

    public lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()

    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView(frame: frame)
    }

    public override func layoutSubviews() {
        if searchBar == nil {
            searchBar = TreeTableViewSearchBar(frame: CGRect(x: 0, y: 0, width: frame.width, height: 40))
            searchBar?.delegate = self
        }
        tableView.frame = CGRect(x: 0, y: 0, width: frame.width, height:frame.height)
    }

    private func initView(frame: CGRect) {
        self.addSubview(tableView)
        if isNeedRefresh {
            tableView.addSubview(refreshControl)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension TreeTableView {

    /// 多选时使用，调用代理
    func prepareCommit() {
        if let data = treeData {
            delegate?.checkNodes(nodes: data.allCheckNodes)
        }
    }

    /// 选中、取消选中所有的节点
    /// - Parameter isCheck: 是否选中
    func checkAllNodes(isCheck: Bool) {
        treeData?.checkAllNode(isCheck: isCheck)
        tableView.reloadData()
    }
    /// 展开、收起所有节点
    /// - Parameter isExpand: 是否展开
    func expandAllNodes(isExpand: Bool) {
        expandNodesWithLevel(level: isExpand ? Int.max : 0)
    }

    /// 展开、收起指定层级的节点
    /// - Parameter isExpand: 是否展开
    /// - Parameter level: 展开等级
    func expandNodesWithLevel(level: Int) {
        treeData?.expandNodeWithLevel(expandLevel: level, noExpandCompleted: { noExpandNodes in
            selectNodes(nodes: noExpandNodes, isExpand: false)
        }, expandCompleted: { expandCompleted in
            selectNodes(nodes: expandCompleted, isExpand: true)
        })
    }

    /// 刷新
    func reload() {
        tableView.reloadData()
    }

}

extension TreeTableView {
    ///勾选传入的节点ID
    private func initCheckNodesID() {
        guard let data = treeData else {
            return
        }
        if checkNodesID.count <= 0 {
            return
        }
        for ID in checkNodesID {
            if let node = data.getNodeByID(ID: ID) {
                data.checkNode(node: node, isCheck: true, isChildNodesCheck: isChildCheck)
                var expandParentNodes = [TreeNode]()
                var parentNode = node.parentNode
                while parentNode != nil {
                    expandParentNodes.append(parentNode!)
                    parentNode = parentNode?.parentNode
                }
                for expandParentNode in expandParentNodes {
                    _ = data.expandNode(node: expandParentNode, isExpand: true)
                }
            }
        }
    }

    @objc
    private func refreshData() {
        delegate?.refreshData?()
        if isNeedRefresh, let tempSearchBar = searchBar {
            search(searchBar: tempSearchBar)
        }
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    private func selectNodes(nodes: [TreeNode], isExpand: Bool) {
        var updateIndexPaths = [IndexPath]()
        var editIndexPaths = [IndexPath]()

        for node in nodes {
            if let index = treeData?.showNodes.firstIndex(of: node) {
                let indexPath = IndexPath(row: index, section: 0)
                updateIndexPaths.append(indexPath)
                let updateNum = treeData!.expandNode(node: node)
                let tempIndexPaths = getUpdateIndexPathsWithCurrentIndexPath(indexPath: indexPath, updateNum: updateNum)
                editIndexPaths.append(contentsOf: tempIndexPaths)
            }
        }
        if isExpand {
            tableView.insertRows(at: editIndexPaths, with: .fade)
        } else {
            tableView.deleteRows(at: editIndexPaths, with: .fade)
        }

        for updateIndexPath in updateIndexPaths {
            let cell = tableView.cellForRow(at: updateIndexPath) as? TreeTableViewCell
            cell?.refreshArrow()
        }
    }

    private func getUpdateIndexPathsWithCurrentIndexPath(indexPath: IndexPath, updateNum: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for index in 0..<updateNum {
            let tempIndexPath = IndexPath(row: indexPath.row + 1 + index, section: indexPath.section)
            indexPaths.append(tempIndexPath)
        }
        return indexPaths
    }
}

extension TreeTableView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return treeData?.showNodes.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let node = treeData?.showNodes[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier:TreeTableViewCell.description()) as? TreeTableViewCell
        if cell == nil {
            cell = TreeTableViewCell(style: .default, reuseIdentifier: TreeTableViewCell.description())
        }
        cell?.isSingleCheck = isSingleCheck
        cell?.treeNode = node
        cell?.cellTextStyle = cellTextStyle
        cell?.checkClick = { nodeModel in
            if self.isSingleCheck {
                self.delegate?.checkNodes(nodes: [nodeModel])
            } else {
                self.treeData!.checkNode(node: node!, isChildNodesCheck: self.isChildCheck)
                tableView.reloadData()
            }
        }
        return cell!
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return isShowSearchBar ? searchBar : nil
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isShowSearchBar ? searchBar?.bounds.height ?? 0 : 0
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = treeData?.showNodes[indexPath.row]
        selectNodes(nodes: [node!], isExpand: !node!.isExpand)
    }

}

extension TreeTableView: TreeTableViewSearchBarDelegate {
    /// 搜索框开始输入
    public func treeTableViewSearchBarDidBeginEditing(searchBar: TreeTableViewSearchBar) {

    }

    public func treeTableViewSearchBarShouldReturn(searchBar: TreeTableViewSearchBar) {
        search(searchBar: searchBar)
    }

    public func treeTableViewSearchBarSearhing(searchBar: TreeTableViewSearchBar) {
        if isSearchRealTime, searchBar.searchTextField.markedTextRange == nil {
            search(searchBar: searchBar)
        }
    }

    @objc
    open func search(searchBar: TreeTableViewSearchBar) {
        var filed = searchBar.searchTextField.text!
        if let tempFiled = delegate?.beforeSearch?(filed: filed) {
            filed = tempFiled
        }
        treeData?.filterFieldAndType(filed: filed, type: typeForSearch, isChildNodeCheck: !isSingleCheck)
        tableView.reloadData()
    }
}
