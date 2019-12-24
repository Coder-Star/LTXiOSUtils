//
//  ToolBarView.swift
//  LTXiOSUtils
//  弹出框顶部显示view
//  Created by 李天星 on 2019/11/21.
//

import UIKit

open class ToolBarView: UIView {

    typealias CustomClosures = (_ titleLabel: UILabel, _ cancleBtn: UIButton, _ doneBtn: UIButton) -> Void
    public typealias BtnAction = () -> Void

    open var title = "PickerViewManager.ToolBarView.title".localizedOfLTXiOSUtils() {
        didSet {
            titleLabel.text = title
        }
    }

    open var doneAction: BtnAction?
    open var cancelAction: BtnAction?

    // 用来产生上下分割线的效果
    fileprivate lazy var contentView: UIView = {
        let content = UIView()
        content.backgroundColor = UIColor.white.adapt()
        return content
    }()

    // 文本框
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black.adapt()
        label.textAlignment = .center
        return label
    }()

    // 取消按钮
    fileprivate lazy var cancleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("cancel".localizedOfLTXiOSUtils(), for: UIControl.State())
        btn.setTitleColor(UIColor.black.adapt(), for: UIControl.State())
        return btn
    }()

    // 完成按钮
    fileprivate lazy var doneBtn: UIButton = {
        let donebtn = UIButton()
        donebtn.setTitle("complete".localizedOfLTXiOSUtils(), for: UIControl.State())
        donebtn.setTitleColor(UIColor.black.adapt(), for: UIControl.State())
        return donebtn
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func commonInit() {
        backgroundColor = UIColor.lightText
        addSubview(contentView)
        contentView.addSubview(cancleBtn)
        contentView.addSubview(doneBtn)
        contentView.addSubview(titleLabel)

        doneBtn.addTarget(self, action: #selector(self.doneBtnOnClick(_:)), for: .touchUpInside)
        cancleBtn.addTarget(self, action: #selector(self.cancelBtnOnClick(_:)), for: .touchUpInside)
    }

    @objc func doneBtnOnClick(_ sender: UIButton) {
        doneAction?()
    }

    @objc func cancelBtnOnClick(_ sender: UIButton) {
        cancelAction?()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        let margin = 15.0
        let contentHeight = Double(bounds.size.height) - 2.0
        contentView.frame = CGRect(x: 0.0, y: 1.0, width: Double(bounds.size.width), height: contentHeight)
        let btnWidth = contentHeight

        cancleBtn.frame = CGRect(x: margin, y: 0.0, width: btnWidth, height: btnWidth)
        doneBtn.frame = CGRect(x: Double(bounds.size.width) - btnWidth - margin, y: 0.0, width: btnWidth, height: btnWidth)
        let titleX = Double(cancleBtn.frame.maxX) + margin
        let titleW = Double(bounds.size.width) - titleX - btnWidth - margin

        titleLabel.frame = CGRect(x: titleX, y: 0.0, width: titleW, height: btnWidth)
    }

}
