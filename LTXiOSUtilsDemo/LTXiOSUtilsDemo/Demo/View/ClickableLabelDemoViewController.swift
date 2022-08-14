//
//  ClickableLabelDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/8/13.
//

import Foundation
import UIKit

class ClickableLabelDemoViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let labelBackgroundView = LabelBackgroundView()
        labelBackgroundView.backgroundColor = .yellow
        view.addSubview(labelBackgroundView)
        labelBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }

        let label = ClickableLabel()

        label.text = "111#你好#111高亮高亮高亮高亮高亮高亮高亮"
        label.clickTextColor = .red
        label.numberOfLines = 2
        label.clickBackgroundColor = .blue
        label.clickTextPatterns = ["#你好#"]
        label.delegate = self
        labelBackgroundView.addSubviews(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
        }
    }
}

extension ClickableLabelDemoViewController: ClickableLabelDelegate {
    func clickableLabel(label: ClickableLabel, clickText text: String) {
        Log.d(text)
    }
}

class LabelBackgroundView: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Log.d("LabelBackgroundView touchesBegan")
    }
}
