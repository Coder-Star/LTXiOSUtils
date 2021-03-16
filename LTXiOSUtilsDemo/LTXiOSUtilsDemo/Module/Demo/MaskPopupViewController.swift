//
//  MaskPopupViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/11/13.
//  Copyright © 2020 李天星. All rights reserved.
//

import UIKit
import LTXiOSUtils

class MaskPopupViewController: BaseUIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "蒙板弹出"
        let rightBarButtonItem = UIBarButtonItem(title: "弹出蒙板", style: .plain, target: self, action: #selector(maskPopup))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc
    func maskPopup() {
        let contentView = UIScrollView(frame: CGRect(x: 20, y: 100, width: Constants.Size.WIDTH - 40, height: 100))

        let redView = UIView()
        redView.backgroundColor = .red
        contentView.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(500)
            make.width.equalTo(contentView.tx.width)
        }

        let popupView = MaskPopupView(containerView: UIApplication.shared.keyWindow!, contentView: contentView, animator: MaskPopupViewFadeInOutAnimator())
        popupView.display(animated: true, completion: nil)
    }
}
