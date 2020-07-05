//
//  ViewEventViewController.swift
//  LTXiOSUtilsDemo
//  测试View事件
//  Created by 李天星 on 2020/7/4.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils

class ViewEventViewController: BaseUIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ViewEvent"
        initUI()
    }
}

extension ViewEventViewController {
    func initUI() {
        let parentView = UIView()
        parentView.backgroundColor = .red
        baseView.add(parentView)
        parentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(500)
            make.width.equalTo(350)
        }

        let blueChildView = UIView()
        blueChildView.backgroundColor = .blue
        parentView.add(blueChildView)
        blueChildView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(200)
        }

        let yellowChildView = TapTestView()
        yellowChildView.backgroundColor = .yellow
        parentView.add(yellowChildView)
        yellowChildView.snp.makeConstraints { make in
            make.top.equalTo(blueChildView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(200)
        }

        // 点击事件测试
        parentView.addTapGesture { _ in
            Log.d("parentView被点击")
        }

//        yellowChildView.addTapGesture { _ in
//            Log.d("yellowChildView被点击")
//        }
    }
}

class TapTestView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        Log.d(point)
        return super.hitTest(point, with: event)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self)
            Log.d(touchPoint)
            Log.d(touch.type.rawValue)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
