//
//  BaseGroupTableMenuViewController.swift
//  Alamofire
//
//  Created by 李天星 on 2019/11/19.
//

import Foundation

class BaseGroupTableMenuViewController: BaseUIViewController {

    lazy var groupTableView:UITableView = {
        let groupTableView = UITableView(frame:baseView.frame, style:.grouped)
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
    var menu = [[[String:String]]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }

    func initTableView() {
        baseView.addSubview(groupTableView)
        locationTableView()
    }

    func locationTableView() {
        groupTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
// MARK: - UITableViewDataSource
extension BaseGroupTableMenuViewController:UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[section].count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell = tableView.dequeueReusableCell(withIdentifier: ConstantsEnum.cell)
        if tableCell == nil {
            tableCell = UITableViewCell(style:.default, reuseIdentifier: ConstantsEnum.cell) //将default换成subtitle可以显示副标题
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
extension BaseGroupTableMenuViewController:UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
