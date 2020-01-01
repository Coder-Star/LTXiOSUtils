//
//  BaseUIScrollViewController.swift
//  LTXiOSUtils
//  基础滚动视图
//  Created by 李天星 on 2020/1/1.
//

import UIKit
import SnapKit

open class BaseUIScrollViewController: BaseViewController {

    public let screenWidth = UIScreen.main.bounds.size.width

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

    /// 添加其他视图，与baseScrollView层次相同
    open func initOtherView() {

    }

    /// 初始化滚动视图并加入view
    open func initBaseUIScrollView() {
        view.backgroundColor = .white
        view.addSubview(baseScrollView)
        positionUIScrollView()
        initScrollSubViews()
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

    /// 初始化滚动视图子视图
    open func initScrollSubViews() {
        let contentView = UIView()
        baseScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(screenWidth)
        }
        setScrollSubViews(contentView: contentView)
    }

    /// 设置滚动视图子view，子类重写,最后一个控件需要设置底部约束,如下
    /// make.bottom.equalToSuperview()
    open func setScrollSubViews(contentView: UIView) {

    }

}
