//
//  ToolBarView.swift
//  LTXiOSUtils
//  弹出框顶部显示view
//  Created by 李天星 on 2019/11/21.
//

import UIKit

open class ToolBarView: UIView {

    /// 取消按钮颜色
    public static var cancelButtonColor: UIColor = UIColor.black.adapt()
    /// 完成按钮颜色
    public static var doneButtonColor: UIColor = UIColor.black.adapt()
    /// 中间title颜色
    public static var centerLabelColor: UIColor = UIColor.black.adapt()

    typealias CustomClosures = (_ titleLabel: UILabel, _ cancleBtn: UIButton, _ doneBtn: UIButton) -> Void
    public typealias BtnAction = () -> Void

    open var title = "" {
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
        label.textColor = ToolBarView.centerLabelColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    // 取消按钮
    fileprivate lazy var cancleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("cancel".localizedOfLTXiOSUtils(), for: UIControl.State())
        btn.setTitleColor(ToolBarView.cancelButtonColor, for: UIControl.State())
        return btn
    }()

    // 完成按钮
    fileprivate lazy var doneBtn: UIButton = {
        let donebtn = UIButton()
        donebtn.setTitle("complete".localizedOfLTXiOSUtils(), for: UIControl.State())
        donebtn.setTitleColor(ToolBarView.doneButtonColor, for: UIControl.State())
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
        let margin: CGFloat = 15
        let contentHeight = bounds.size.height - 2
        contentView.frame = CGRect(x: 0, y: 1, width: bounds.size.width, height: contentHeight)
        let cancleBtnSize = cancleBtn.sizeThatFits(CGSize(width: 0, height: contentHeight))
        let doneBtnSize = doneBtn.sizeThatFits(CGSize(width: 0, height: contentHeight))
        cancleBtn.frame = CGRect(x: margin, y: 0, width: cancleBtnSize.width, height: contentHeight)
        doneBtn.frame = CGRect(x: bounds.size.width - doneBtnSize.width - margin, y: 0, width: doneBtnSize.width, height: contentHeight)
        let titleX = cancleBtn.frame.maxX + margin
        let titleW = bounds.size.width - titleX - doneBtnSize.width - margin

        titleLabel.frame = CGRect(x: titleX, y: 0.0, width: titleW, height: contentHeight)
    }

}
