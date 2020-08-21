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
            make.height.equalTo(600)
            make.width.equalTo(350)
        }

        let blueChildView = TapTestView()
        blueChildView.backgroundColor = .blue
        parentView.add(blueChildView)
        blueChildView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(200)
        }

        let yellowChildView = UIView()
        yellowChildView.backgroundColor = .yellow
        parentView.add(yellowChildView)
        yellowChildView.snp.makeConstraints { make in
            make.top.equalTo(blueChildView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(200)
        }

        let greenButton = UIButton()
        greenButton.setTitle("按钮", for: .normal)

        greenButton.backgroundColor = .green
        parentView.add(greenButton)
        greenButton.snp.makeConstraints { make in
            make.top.equalTo(yellowChildView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(50)
        }
//        greenButton.addTapGesture { _ in
//            Log.d("greenButton被点击")
//        }
        greenButton.addTarget(self, action: #selector(click), for: .touchUpInside)

        // 点击事件测试
        parentView.addTapGesture { _ in
            Log.d("parentView被点击")
        }

        yellowChildView.addTapGesture { _ in
            Log.d("yellowChildView被点击")
        }
        /*
         现在yellowChildView为普通UIView，blueChildView为自定义UIView，可以看到点击yellowChildView时没有坐标输出
         原因是因为view在hitTest遍历自己的子View是按照加入的顺序倒序查找的
        */

        blueChildView.addTapGesture { _ in
            //        tap.cancelsTouchesInView = false
            //        tap.delaysTouchesBegan = true
            //        tap.delaysTouchesEnded = false
            Log.d("blueChildView被点击、手势")
        }

    }

    @objc func click() {
        Log.d("按钮Action")
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
        Log.d("触摸事件开始")
        for touch in touches {
            let touchPoint = touch.location(in: self)
            Log.d(touch.tapCount)
            Log.d(touch.timestamp)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Log.d("触摸事件结束")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        Log.d("触摸事件移动")
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        Log.d("触摸事件取消")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TapTestButton: UIButton {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        Log.d("按钮Tracking开始")
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {

    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
       return true
    }

    override func cancelTracking(with event: UIEvent?) {
        Log.d("按钮Tracking取消")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Log.d("触摸事件开始")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Log.d("触摸事件结束")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        Log.d("触摸事件移动")
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        Log.d("触摸事件取消")
    }
}

extension UIButton {
//    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        Log.d("按钮Tracking开始")
//        return true
//    }
//
//    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
//
//    }
//
//    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//       return true
//    }
//
//    override open func cancelTracking(with event: UIEvent?) {
//        Log.d("按钮Tracking取消")
//    }
//
//    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Log.d("触摸事件开始")
//    }
//
//    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Log.d("触摸事件结束")
//    }
//
//    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Log.d("触摸事件移动")
//    }
//
//    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Log.d("触摸事件取消")
//    }
}
