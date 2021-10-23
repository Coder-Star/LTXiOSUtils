//
//  TreeTableViewSearchBar.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2020/2/1.
//

import Foundation

/// 协议
public protocol TreeTableViewSearchBarDelegate: AnyObject {
    /// 输入框开始进行编辑
    func treeTableViewSearchBarDidBeginEditing(searchBar: TreeTableViewSearchBar)
    /// 点击键盘搜索键
    func treeTableViewSearchBarShouldReturn(searchBar: TreeTableViewSearchBar)
    /// 实时搜索
    func treeTableViewSearchBarSearhing(searchBar: TreeTableViewSearchBar)
}

public class TreeTableViewSearchBar: UIView {
    public lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 5
        searchTextField.placeholder = "请输入关键字进行搜索"
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.adjustsFontSizeToFitWidth = true
        searchTextField.returnKeyType = .search
        searchTextField.leftViewMode = .always
        searchTextField.backgroundColor = .white
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(search), for: .editingChanged)
        return searchTextField
    }()

    public weak var delegate: TreeTableViewSearchBarDelegate?

    public var text: String? {
        return searchTextField.text
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor(hexString: "#eeeeee")
        addSubview(searchTextField)

        searchTextField.frame = CGRect(x: 5, y: 5, width: frame.size.width - 10, height: frame.size.height - 10)
        searchTextField.leftView = getLeftView(height: frame.size.height - 10)
    }

    private func getLeftView(height: CGFloat) -> UIView {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.frame = CGRect(x: 0, y: 0, width: height, height: height)
        button.contentEdgeInsets = UIEdgeInsets(top: height / 4, left: height / 4, bottom: height / 4, right: height / 4)
        button.setImage("TreeTableView_search".imageOfLTXiOSUtilsComponent, for: .normal)
        return button
    }
}

extension TreeTableViewSearchBar: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.treeTableViewSearchBarDidBeginEditing(searchBar: self)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.treeTableViewSearchBarShouldReturn(searchBar: self)
        textField.resignFirstResponder()
        return true
    }

    @objc
    private func search() {
        delegate?.treeTableViewSearchBarSearhing(searchBar: self)
    }
}
