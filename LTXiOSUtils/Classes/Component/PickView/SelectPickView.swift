//
//  SelectPickView.swift
//  LTXiOSUtils
//  选择器(多选)
//  Created by 李天星 on 2019/12/30.
//

import Foundation

// MARK: - 属性
public class SelectPickView: UIView {

    public typealias ClearBlock = () -> Void
    public typealias SureBlock = (_ indexArr: [Int], _ valueArr: [String]) -> Void
    public typealias SingleSureBlock = (_ index: Int, _ value: String) -> Void

    /// 数据
    public var titleArr = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    /// 选中的索引数组，多选
    private var selectIndexArr = [Int]()
    /// 选中的索引，单选
    private var selectIndex: Int?

    /// 清空按钮闭包
    public var clearBlock: ClearBlock?
    /// 确定按钮闭包,多选
    public var sureBlock: SureBlock?
    /// 确定按钮闭包,单选
    public var singleSureBlock: SingleSureBlock?

    /// toobar高度
    private let toolBarHeight: CGFloat = 44
    /// tableview高度
    private let tableViewHeight: CGFloat = 216
    /// 总高度
    private var pickHeight: CGFloat {
        return toolBarHeight + tableViewHeight
    }

    /// 是否单项选择
    private var isSingle = false

    /// 屏幕高度
    private let screenHeight = UIScreen.main.bounds.height
    /// 屏幕宽度
    private let screenWidth = UIScreen.main.bounds.width
    /// 隐藏时frame
    private var hideFrame: CGRect {
        return CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: pickHeight)
    }
    /// 显示时frame
    private var showFrame: CGRect {
        return CGRect(x: 0.0, y: screenHeight - pickHeight, width: screenWidth, height: pickHeight)
    }

    // MARK: - 私有控件
    private lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
        coverView.backgroundColor = UIColor.black.adapt()
        coverView.alpha = 0
        coverView.addTapGesture { [weak self] _ in
            self?.dismiss()
        }
        return coverView
    }()

    private lazy var pickView: UIView = {
        let pickView = UIView()
        pickView.frame = hideFrame
        return pickView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 35
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private lazy var toolBarView: ToolBarView = {
        let toolBarView = ToolBarView()
        return toolBarView
    }()

    private lazy var normalImage: UIImage? = {
        let normalImage = "SelectPickView_select_normal".imageOfLTXiOSUtils()?.setSize(reSize: CGSize(width: 25, height: 25))
        return normalImage
    }()

    private lazy var selectdImage: UIImage? = {
        let selectdImage = "SelectPickView_select_selected".imageOfLTXiOSUtils()?.setSize(reSize: CGSize(width: 25, height: 25))
        return selectdImage
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.frame = self.superview?.bounds ?? UIScreen.main.bounds
        self.addSubview(coverView)
        self.addSubview(pickView)
        pickView.addSubview(toolBarView)
        pickView.addSubview(tableView)

        toolBarView.clearAction = { [weak self] in
            self?.clearBlock?()
            self?.dismiss()
        }
        toolBarView.doneAction = {
            if self.isSingle {
                if let tempIndex = self.selectIndex {
                    self.singleSureBlock?(tempIndex, self.titleArr[tempIndex])
                    self.dismiss()
                } else {
                    HUD.showText("SelectPickView.selectOne".localizedOfLTXiOSUtils())
                }
            } else {
                if self.selectIndexArr.isEmpty {
                    HUD.showText("SelectPickView.selectAtLeastOne".localizedOfLTXiOSUtils())
                } else {
                    let indexArr = self.selectIndexArr.sorted()
                    var valueArr = [String]()
                    for item in indexArr {
                        valueArr.append(self.titleArr[item])
                    }
                    self.sureBlock?(indexArr, valueArr)
                    self.dismiss()
                }
            }
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        toolBarView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: toolBarHeight)
        tableView.frame = CGRect(x: 0, y: toolBarHeight, width: screenWidth, height: tableViewHeight)
    }

}

// MARK: - 对外暴露方法
public extension SelectPickView {

    /// 展示多选view
    /// - Parameters:
    ///   - title: 标题
    ///   - data: 数据
    ///   - defaultSelectedIndex: 默认选中索引
    ///   - sureBlock: 确定闭包
    class func showView(title: String, data: [String], defaultSelectedIndexs: [Int]?, clearBlock: @escaping ClearBlock, sureBlock: @escaping SureBlock) {
        guard let view = getView(title: title, data: data, defaultSelectedIndexs: defaultSelectedIndexs) else {
            return
        }
        view.clearBlock = clearBlock
        view.sureBlock = sureBlock
        view.show()
    }

    /// 获取多选view
    /// - Parameters:
    ///   - title: 标题
    ///   - data: 数据
    ///   - defaultSelectedIndexs: 默认选中索引,如果为nil，表示都不选中
    class func getView(title: String, data: [String], defaultSelectedIndexs: [Int]?) -> SelectPickView? {
        if data.isEmpty {
            HUD.showText("SelectPickView.emptyData".localizedOfLTXiOSUtils())
            return nil
        }
        UIApplication.shared.keyWindow?.endEditing(true)
        let view = SelectPickView()
        view.titleArr = data
        if let indexArr = defaultSelectedIndexs {
            for item in indexArr where (item >= 0 && item < data.count) {
                view.selectIndexArr.append(item)
            }
        }
        view.toolBarView.title = title
        return view
    }

    /// 展示单选view
    /// - Parameters:
    ///   - title: 标题
    ///   - data: 数据
    ///   - defaultSelectedIndex: 默认选中索引
    ///   - sureBlock: 确定闭包
    class func showSingleView(title: String, data: [String], defaultSelectedIndex: Int?, clearBlock: @escaping ClearBlock, sureBlock: @escaping SingleSureBlock) {
        guard let view = getSingleView(title: title, data: data, defaultSelectedIndex: defaultSelectedIndex) else {
            return
        }
        view.clearBlock = clearBlock
        view.singleSureBlock = sureBlock
        view.show()
    }

    /// 获取单选view
    /// - Parameters:
    ///   - title: 标题
    ///   - data: 数据
    ///   - defaultSelectedIndexs: 默认选中索引,如果为nil，表示都不选中
    class func getSingleView(title: String, data: [String], defaultSelectedIndex: Int?) -> SelectPickView? {
        if data.isEmpty {
            HUD.showText("SelectPickView.emptyData".localizedOfLTXiOSUtils())
            return nil
        }
        UIApplication.shared.keyWindow?.endEditing(true)
        let view = SelectPickView()
        view.titleArr = data
        if let index = defaultSelectedIndex, index >= 0, index < data.count {
            view.selectIndex = index
        }
        view.isSingle = true
        view.toolBarView.title = title
        return view
    }

    /// 弹出框显示
    func show() {
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.pickView.frame = self.showFrame
            self.coverView.alpha = 0.1
            }, completion: { _ in
        })
    }

    /// 弹出框消失
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.pickView.frame = self.hideFrame
            self.coverView.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
        })
    }
}

// MARK: - UITableView相关代理
extension SelectPickView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SelectPickViewTableCell.description()) as? SelectPickViewTableCell
        if cell == nil {
            cell = SelectPickViewTableCell(style: .default, reuseIdentifier: SelectPickViewTableCell.description())
        }
        cell?.titleLabel.text = titleArr[indexPath.row]
        if isSingle {
            if selectIndex == indexPath.row {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
        } else {
            if selectIndexArr.contains(indexPath.row) {
                cell?.accessoryView = UIImageView(image: selectdImage)
            } else {
                cell?.accessoryView = UIImageView(image: normalImage)
            }
        }
        return cell!
    }
}

extension SelectPickView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSingle {
            selectIndex = indexPath.row
        } else {
            if let index = selectIndexArr.firstIndex(of: indexPath.row) {
                selectIndexArr.remove(at: index)
            } else {
                selectIndexArr.append(indexPath.row)
            }
        }
        tableView.reloadData()
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == titleArr.count - 1 {
            tableView.layoutIfNeeded()
            /// 为tableView加上header,使内容垂直居中
            let margin = tableViewHeight - tableView.contentSize.height
            if margin > 0 {
                let headerView = UIView(frame: CGRect(x: 0.cgFloatValue, y: 0, width: screenWidth, height: margin / 2))
                let lineView = UIView(frame: CGRect(x: 0.cgFloatValue, y: headerView.frame.height - 0.05, width: screenWidth, height: 0.05))
                lineView.backgroundColor = UIColor(hexString: "#bbbbbb")
                headerView.addSubview(lineView)
                tableView.tableHeaderView = headerView
            }
        }
    }
}

class SelectPickViewTableCell: UITableViewCell {

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byCharWrapping
        return titleLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    private func setupView() {
        separatorInset = .zero
        selectionStyle = .none
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 50))
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}
