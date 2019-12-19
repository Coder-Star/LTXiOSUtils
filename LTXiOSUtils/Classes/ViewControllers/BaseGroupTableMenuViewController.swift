//
//  BaseGroupTableMenuViewController.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/11/19.
//

import Foundation
import UIKit

open class BaseGroupTableMenuViewController: BaseUIViewController {

    public lazy var groupTableView: UITableView = {
        let groupTableView = UITableView(frame: baseView.frame, style: .grouped)
        groupTableView.delegate = self
        groupTableView.dataSource = self
        return groupTableView
    }()

    /// 菜单
    public var menu = [[BaseGroupTableMenuModel]]()

    override open func viewDidLoad() {
        super.viewDidLoad()
        setMenu()
        initTableView()
    }

    open func setMenu() {

    }

    open func initTableView() {
        baseView.addSubview(groupTableView)
        locationTableView()
    }

    open func locationTableView() {
        groupTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
// MARK: - UITableViewDataSource
extension BaseGroupTableMenuViewController: UITableViewDataSource {

    /// 分组个数
    open func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }

    /// 每组cell个数
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[section].count
    }

    /// sectionFooter高度
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    /// sectionFooterView
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    /// sectionHeader高度
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    /// sectionHeaderView
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    /// 渲染每一个cell
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell = tableView.dequeueReusableCell(withIdentifier: ConstantsEnum.tableCell)
        if tableCell == nil {
            tableCell = UITableViewCell(style: .default, reuseIdentifier: ConstantsEnum.tableCell)
        }
        tableCell?.textLabel?.text = menu[indexPath.section][indexPath.row].title
        tableCell?.imageView?.image = menu[indexPath.section][indexPath.row].image
        tableCell?.accessoryType = .disclosureIndicator
        return tableCell!
    }

}

// MARK: - UITableViewDataSource
extension BaseGroupTableMenuViewController: UITableViewDelegate {

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        click(menuModel: menu[indexPath.section][indexPath.row])
    }

    @objc open func click(menuModel: BaseGroupTableMenuModel) {

    }

}

public class BaseGroupTableMenuModel: NSObject {
    /// 编码
    public var code: String
    /// 标题
    public var title: String
    /// 图片
    public var image: UIImage?

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
    public init(code: String, title: String) {
        self.code = code
        self.title = title
        self.image = nil
    }

}
