//
//  FlutterMainViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/14.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils
import Flutter

class FlutterMainViewController: BaseUIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Flutter"

        let rightBarButtonItem = UIBarButtonItem(title: "进入Flutter", style: .plain, target: self, action: #selector(action))
        navigationItem.rightBarButtonItem = rightBarButtonItem

    }

    @objc
    func action() {
        guard let delegate = (UIApplication.shared.delegate as? ApplicationServiceManagerDelegate)?.getService(by: FlutterApplicationService.self) as? FlutterApplicationService else {
            return
        }
        Log.d(delegate.flutterEngine)
        Log.d(navigationController?.viewControllers)

        /**
         在iOS模拟器下，第二次使用engin 创建FlutterViewContainer时， initWithEngine: 会crash，报错如下
         Thread 1: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
         原因是僵尸指针导致
         真机上不会出现
         */
        guard let viewController = FlutterViewController(engine: delegate.flutterEngine, nibName: nil, bundle: nil) else {
            return
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
