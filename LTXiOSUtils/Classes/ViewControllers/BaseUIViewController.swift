//
//  BaseUIViewController.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2019/11/19.
//

import Foundation
import SnapKit

class BaseUIViewViewController: BaseViewController {

    /// 基础view
    private lazy var baseView:UIView = {
        return UIView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initBaseView()
    }

    /// 设置基础view颜色以及约束
    func initBaseView() {
        baseView.backgroundColor = .white
        view.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                make.bottom.equalTo(bottomLayoutGuide.snp.bottom)
            }
            make.left.right.equalToSuperview()
        }
    }

}
