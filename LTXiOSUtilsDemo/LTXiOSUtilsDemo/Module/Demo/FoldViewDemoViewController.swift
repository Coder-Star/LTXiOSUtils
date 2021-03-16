//
//  FoldViewDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/11/24.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils

class FoldViewDemoViewController: BaseUIViewController {
    private lazy var tableView: UITableView = {
        let tableView = FoldTableView(frame: .zero, style: .grouped)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 5
        tableView.sectionFooterHeight = 5
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        return tableView
    }()

    override func viewDidLoad() {
        baseView.backgroundColor = .gray
        super.viewDidLoad()
        baseView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }
}

// MARK: - 以下四个代理都需要实现
extension FoldViewDemoViewController: FoldTableViewDataSource {
    func tableView(_ tableView: FoldTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "section: \(section)"
        return cell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "section: \(indexPath.section)  row: \(indexPath.row)"
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

extension FoldViewDemoViewController: FoldTableViewDelegate {

}
