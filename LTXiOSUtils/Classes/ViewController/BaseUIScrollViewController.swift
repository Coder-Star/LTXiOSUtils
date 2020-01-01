//
//  BaseUIScrollViewController.swift
//  LTXiOSUtils
//  基础滚动视图
//  Created by 李天星 on 2020/1/1.
//

import UIKit
import SnapKit

open class BaseUIScrollViewController: BaseViewController {

    private let screenWidth = UIScreen.main.bounds.size.width

    /// 基础滚动View
    public lazy var baseScrollView: UIScrollView = {
        let baseScrollView = UIScrollView()
        baseScrollView.backgroundColor = .white
        baseScrollView.alwaysBounceVertical = true
        baseScrollView.isScrollEnabled = true
        return baseScrollView
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()
        initOtherView()
        initBaseUIScrollView()
        //避免ios 11以下系统页面向下偏移
        self.automaticallyAdjustsScrollViewInsets = false
    }

    /// 添加其他视图
    open func initOtherView() {

    }

    /// 初始化滚动视图
    open func initBaseUIScrollView() {
        view.addSubview(baseScrollView)
        positionUIScrollView()
    }

    /// 定位滚动视图
    open func positionUIScrollView() {
        baseScrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.width.equalTo(screenWidth)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                make.bottom.equalTo(bottomLayoutGuide.snp.bottom)
            }
        }
    }

}
