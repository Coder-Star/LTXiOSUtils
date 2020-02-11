//
//  MultiSelectPickView.swift
//  LTXiOSUtils
//  选择器(多选)
//  Created by 李天星 on 2019/12/30.
//

import Foundation

// MARK: - 属性
public class MultiSelectPickView: UIView {

    public typealias ClearBlock = () -> Void
    public typealias SureBlock = (_ indexArr: [Int], _ valueArr: [String]) -> Void

    /// 数据
    public var titleArr = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    /// 选中的索引
    private var selectIndexArr = [Int]()

    /// 清空按钮闭包
    public var clearBlock: ClearBlock?
    /// 确定按钮闭包
    public var sureBlock: SureBlock?

    /// toobar高度
    private let toolBarHeight: CGFloat = 44
    /// tableview高度
    private let tableViewHeight: CGFloat = 216
    /// cell高度
    private let rowHeight: CGFloat = 35
    /// 总高度
    private var pickHeight:CGFloat {
        return toolBarHeight + tableViewHeight
    }

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

    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = rowHeight
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private lazy var toolBarView: ToolBarView = {
        let toolBarView = ToolBarView()
        return toolBarView
    }()

    private lazy var normalImage:UIImage? = {
        let normalImage = "MultiSelectPickView_select_normal".imageOfLTXiOSUtils()?.setSize(reSize: CGSize(width: 25, height: 25))
        return normalImage
    }()

    private lazy var selectdImage:UIImage? = {
        let selectdImage = "MultiSelectPickView_select_selected".imageOfLTXiOSUtils()?.setSize(reSize: CGSize(width: 25, height: 25))
        return selectdImage
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
            if self.selectIndexArr.isEmpty {
                HUD.showText("MultiSelectPickView.selectAtSelectOne".localizedOfLTXiOSUtils())
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

    override public func layoutSubviews() {
        super.layoutSubviews()
        toolBarView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: toolBarHeight)
        tableView.frame = CGRect(x: 0, y: toolBarHeight, width: screenWidth, height: tableViewHeight)

        /// 为tableView加上header,使内容垂直居中
        let margin = tableViewHeight - rowHeight * titleArr.count.cgFloatValue
        if margin > 0 {
            let headerView = UIView(frame: CGRect(x: 0.cgFloatValue, y: 0, width: screenWidth, height: margin/2))
            let lineView = UIView(frame: CGRect(x: 0.cgFloatValue, y: headerView.frame.height - 0.05, width: screenWidth, height: 0.05))
            lineView.backgroundColor = UIColor(hexString: "#bbbbbb")
            headerView.addSubview(lineView)
            tableView.tableHeaderView = headerView
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 对外暴露方法
public extension MultiSelectPickView {

    /// 展示view
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
    class func getView(title: String, data: [String], defaultSelectedIndexs: [Int]?) -> MultiSelectPickView? {
        if data.isEmpty {
            HUD.showText("MultiSelectPickView.emptyData".localizedOfLTXiOSUtils())
            return nil
        }
        UIApplication.shared.keyWindow?.endEditing(true)
        let view = MultiSelectPickView()
        view.titleArr = data
        if let indexArr = defaultSelectedIndexs {
            for item in indexArr where (item >= 0 && item < data.count) {
                view.selectIndexArr.append(item)
            }
        }
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
extension MultiSelectPickView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.selectionStyle = .none
        cell?.textLabel?.adjustsFontSizeToFitWidth = true
        cell?.textLabel?.text = titleArr[indexPath.row]
        cell?.separatorInset = .zero
        if selectIndexArr.contains(indexPath.row) {
            cell?.accessoryView = UIImageView(image: selectdImage)
        } else {
            cell?.accessoryView = UIImageView(image: normalImage)
        }
        return cell!
    }
}

extension MultiSelectPickView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) , let accessoryView = cell.accessoryView as? UIImageView else {
            return
        }

        if accessoryView.image == normalImage {
            accessoryView.image = selectdImage
            selectIndexArr.append(indexPath.row)
        } else if accessoryView.image == selectdImage {
            accessoryView.image = normalImage
            if let index = selectIndexArr.firstIndex(of: indexPath.row) {
                selectIndexArr.remove(at: index)
            }
        }
    }
}
