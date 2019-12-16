//
//  BaseGroupTableMenuViewController.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/11/19.
//

import Foundation

open class BaseGroupTableMenuViewController: BaseUIViewController {

    lazy var groupTableView: UITableView = {
        let groupTableView = UITableView(frame: baseView.frame, style: .grouped)
        groupTableView.delegate = self
        groupTableView.dataSource = self
        return groupTableView
    }()

    /// 需要设置为这样的形式
    ///    menu = [
    ///     [
    ///         [ConstantsEnum.code:"code",ConstantsEnum.title:"title",ConstantsEnum.image:"image"],
    ///         [ConstantsEnum.code:"code1",ConstantsEnum.title:"title1",ConstantsEnum.image:"image1"]
    ///     ],
    ///     [
    ///         [ConstantsEnum.code:"code2",ConstantsEnum.title:"title2",ConstantsEnum.image:"image2"],
    ///         [ConstantsEnum.code:"code3",ConstantsEnum.title:"title3",ConstantsEnum.image:"image3"]
    ///     ],
    // /   ]
    public var menu = [[[String: String]]]()

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
        var tableCell = tableView.dequeueReusableCell(withIdentifier: ConstantsEnum.cell)
        if tableCell == nil {
            tableCell = UITableViewCell(style: .default, reuseIdentifier: ConstantsEnum.cell)
        }

        if let title = menu[indexPath.section][indexPath.row][ConstantsEnum.title] {
            tableCell?.textLabel?.text = title
        }

        if let image = menu[indexPath.section][indexPath.row][ConstantsEnum.image] {
            tableCell?.imageView?.image = UIImage(named: image)
        }

        tableCell?.accessoryType = .disclosureIndicator
        return tableCell!
    }

}

// MARK: - UITableViewDataSource
extension BaseGroupTableMenuViewController: UITableViewDelegate {

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let code = menu[indexPath.section][indexPath.row][ConstantsEnum.code] {
            click(code: code)
        }
    }

    @objc open func click(code: String) {

    }

}
