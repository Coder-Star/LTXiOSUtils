//
//  StoryboardMainViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/23.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils

class StoryboardMainViewController: BaseViewController {

    let menuList = [
        "performSegue方式跳转"
    ]

    @IBOutlet weak var tableView: UITableView!

    @IBAction
    func unWindInfoForSegue(segue: UIStoryboardSegue) {
        guard let viewController = segue.source as? StoryboardSecondViewController else {
            return
        }
        Log.d(viewController.title)
        Log.d(viewController.infoFromPreviousViewController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        Log.d("StoryboardMainViewController")
    }

    // 使用segue跳转之前被调用的方法，在该回调方法传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue的标识，在storyboard中进行配置
        Log.d(segue.identifier)
        // segue连接的当前页面
        Log.d(segue.source)
        // segue连接的目标跳转页面
        Log.d(segue.destination)
        /**
         如果是控件点击事件跳转到下一个页面，sender就是对于的控件（button或者cell等）或手势（tap等）；
         如果是代码调用（self?.performSegueWithIdentifier("segue的identifile", sender:nil)）用这个方法，那sender传递的什么就是什么
         */
        Log.d(sender)
        if let viewController = segue.destination as? StoryboardSecondViewController {
            viewController.infoFromPreviousViewController = "StoryboardMainViewController"
        }
    }
}

extension StoryboardMainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")!
        cell.textLabel?.text = menuList[indexPath.row]
        return cell
    }
}

extension StoryboardMainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Log.d(indexPath.row)
        switch indexPath.row {
        case 0:
            // StoryboardSecondVCSegue为 StoryboardMainViewController -> StoryboardSecondViewController之间的segue的标识
            performSegue(withIdentifier: "StoryboardSecondVCSegue", sender: nil)
        default:
            break
        }
    }
}
