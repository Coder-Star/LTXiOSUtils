//
//  TreeViewDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/2/3.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils

class TreeViewDemoViewController: BaseUIViewController {

    private var treeView: TreeTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "无限级树形View"
        initView()

        let submitRightButton = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(submit))
        self.navigationItem.rightBarButtonItems = [submitRightButton]
    }

    @objc private func submit() {
        treeView.prepareCommit()
    }

    private func initView() {
        let data = ResourceUtils.getText(url: R.file.treeResourceJson(), type: .json)
        var treeNodes = [TreeNode]()
        for item in data.arrayValue {
            let name = item["name"].stringValue
            let filterName = [item["name"].stringValue]
            let ID = item["id"].stringValue
            let parentID = item["pid"].stringValue
            let sordCode = item["order_no"].intValue
            let type = item["type"].stringValue
            let isTop = item["pid"].stringValue.isEmpty
            let isLeaf = type == "ControlPoint"
            let data = item.object
            let treeNode = TreeNode(name: name, filterName: filterName, ID: ID, parentID: parentID, sordCode: sordCode, type: type, isTop: isTop, isLeaf: isLeaf, data: data)
            treeNodes.append(treeNode)
        }

        let treeData = TreeData(treeNodes: treeNodes)
        baseView.layoutIfNeeded()
        treeView = TreeTableView(frame: baseView.frame) //注意：这里的Frame不可以设置为.zero，否则TreeTableView里面的tableview不会走cellForRowAt代理
        treeView.delegate = self
        treeView.treeData = treeData
        treeView.checkNodesID = ["13043525276202030000"]
        baseView.addSubview(treeView)
        treeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
extension TreeViewDemoViewController: TreeTableViewDelegate {
    func checkNodes(nodes: [TreeNode]) {
        if treeView.isSingleCheck {
            QL1(nodes[0].data)
        } else {
            QL1(nodes.count)
        }
    }
}
