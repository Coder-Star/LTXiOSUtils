//
//  ViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2021/8/9.
//

import UIKit

import UIKit

class ViewController: BaseViewController {
    private var demoList: [[String: Any]] = [
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = demoList[indexPath.row]["title"] as? String
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewControllerType = demoList[indexPath.row]["vc"] as? UIViewController.Type else {
            return
        }
        let viewController = viewControllerType.init()
        viewController.title = demoList[indexPath.row]["title"] as? String
        navigationController?.pushViewController(viewController, animated: true)
    }
}
