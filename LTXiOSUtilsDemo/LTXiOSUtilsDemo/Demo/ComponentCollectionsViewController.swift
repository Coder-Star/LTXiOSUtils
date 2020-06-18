//
//  ComponentCollectionsViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/1/1.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import UIKit
import LTXiOSUtils
import IQKeyboardManagerSwift

class ComponentCollectionsViewController: BaseUIScrollViewController {

    private let leftWidth = 110

    /// 加载按钮
    lazy var spinnerBtn: SpinnerButton = {
        let spinnerBtn = SpinnerButton()
        spinnerBtn.defaultCornerRadius = 5
        spinnerBtn.title = "登录"
        return spinnerBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "控件集锦"
    }

    override func setContentViewSubViews(contentView: UIView) {
        var titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "加载按钮"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(leftWidth)
        }

        contentView.addSubview(spinnerBtn)
        spinnerBtn.tag = 1
        spinnerBtn.addTarget(self, action: #selector(btnClick(button:)), for: .touchUpInside)
        spinnerBtn.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(titleLabel)
        }

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "TextView"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(spinnerBtn.snp.bottom).offset(10)
            make.width.equalTo(leftWidth)
        }

        let textView = ViewFactory.getTextView()
        textView.tag = 100
//        textView.text = "这是内容"
        textView.placeholder = "请输入信息，这是UITextView的扩展"
        textView.limitLength = 10
//        textView.limitLines = 1
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel)
        }
        textView.backgroundColor = .red

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.attributedText = "多样式Label".tx.attributedString
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.width.equalTo(leftWidth)
        }

        let label = CommonShowTextView()
//        label.text = "17812345678"
        label.text = "沿着荷塘，是一条曲折的小煤屑路。这是一条幽僻的路"
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel)
        }

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "滚动view"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(10)
            make.width.equalTo(leftWidth)
        }

        let rollView = RollingNoticeView()
        rollView.delegate = self
        rollView.dataSource = self
        contentView.addSubview(rollView)
        rollView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel)
            make.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rollView)
        }

        rollView.reloadDataAndStartRoll()

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = "高度适应TextView"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(rollView.snp.bottom).offset(10)
            make.width.equalTo(leftWidth)
        }

        let growingTextView = GrowingTextView()
        growingTextView.tag = 200
        growingTextView.layer.borderColor = UIColor(hexString: "#cdcdcd").cgColor
        growingTextView.layer.borderWidth = 0.5
        growingTextView.layer.cornerRadius = 5
        contentView.addSubview(growingTextView)
        growingTextView.minHeight = 100
        growingTextView.maxHeight = 200
        growingTextView.placeholder = "请输入信息"
        growingTextView.limitLength = 100
        growingTextView.growingTextViewDelegate = self
        growingTextView.font = UIFont.systemFont(ofSize: 17)
        growingTextView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel)
        }

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = "加载组件图片"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(growingTextView.snp.bottom).offset(10)
            make.width.equalTo(leftWidth)
        }

        let otherCompentImageView = UIImageView()

        // addImage.png为直接拖动到项目中的图片，不放置到xcassets中去，也可直接读取 addImage以及addImage.png都可以读取
         otherCompentImageView.image = UIImage(named: "addImage.png")

        contentView.addSubview(otherCompentImageView)
        otherCompentImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.top.equalTo(titleLabel)
        }

        otherCompentImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }

    }

    deinit {
        (baseScrollView.viewWithTag(100) as? UITextView)?.removeObserver()
        (baseScrollView.viewWithTag(200) as? UITextView)?.removeObserver()
        NotificationCenter.default.removeObserver(self)
    }
}

extension ComponentCollectionsViewController: GrowingTextViewDelegate {

}

extension GrowingTextViewDelegate {
    func heightChange(growingTextView: GrowingTextView, height: CGFloat) {
        /// 高度自动变化后刷新输入焦点
        IQKeyboardManager.shared.reloadLayoutIfNeeded()
    }
}

extension ComponentCollectionsViewController {
    @objc func btnClick(button: UIButton) {
        switch button.tag {
        case 1:
            spinnerBtn.animate(animation: .load)
            DispatchQueue.main.tx.delay(1) {
                self.spinnerBtn.animate(animation: .default)
            }
            DispatchQueue.main.tx.delay(1.3) {
                self.spinnerBtn.animate(animation: .shake)
            }

        default:
            Log.d("未知点击事件")
        }
    }
}

extension ComponentCollectionsViewController: RollingNoticeViewDataSource, RollingNoticeViewDelegate {

    private var rollList: [String] {
        return ["这是第一条公告",
                "第二条公告开始了"]
    }

    func numberOfRowsFor(roolingView: RollingNoticeView) -> Int {
        return rollList.count
    }

    func rollingNoticeView(roolingView: RollingNoticeView, cellAtIndex index: Int) -> RollingNoticeCell {
        var itemCell = roolingView.dequeueReusableCell(withIdentifier: RollingNoticeCell.description())
        if itemCell == nil {
            itemCell = RollingNoticeCell(reuseIdentifier: RollingNoticeCell.description())
        }
        itemCell?.titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        itemCell!.titleLabel.text = rollList[index]
        return itemCell!
    }

    func rollingNoticeView(_ roolingView: RollingNoticeView, didClickAt index: Int) {
        Log.d(index)
    }
}
