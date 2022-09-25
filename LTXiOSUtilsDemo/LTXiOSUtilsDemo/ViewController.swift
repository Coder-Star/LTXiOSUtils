//
//  ViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2021/8/9.
//

import LTXiOSUtils
import SnapKit
import UIKit
import WebKit

@objc
protocol Info1: AnyObject {}

class ViewController: BaseViewController, Info1 {
    private var demoList: [String: [[String: Any]]] = [
        "UI组件": [
            ["title": "ClickableLabel", "subTitle": "可点击Label", "vc": ClickableLabelDemoViewController.self],
        ],
    ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "功能列表"

        view.addSubview(tableView)
        tableView.frame = view.frame
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return demoList.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(demoList.keys)[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(demoList.values)[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = Array(demoList.values)[indexPath.section][indexPath.row]["title"] as? String
        cell.detailTextLabel?.text = Array(demoList.values)[indexPath.section][indexPath.row]["subTitle"] as? String
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewControllerType = Array(demoList.values)[indexPath.section][indexPath.row]["vc"] as? UIViewController.Type else {
            return
        }
        let viewController = viewControllerType.init()
        viewController.title = Array(demoList.values)[indexPath.section][indexPath.row]["title"] as? String
        navigationController?.pushViewController(viewController, animated: true)
    }
}
