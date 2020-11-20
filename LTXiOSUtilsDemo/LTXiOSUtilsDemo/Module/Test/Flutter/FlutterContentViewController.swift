//
//  FlutterContentViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/11/17.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import Flutter

class FlutterContentViewController: FlutterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        Log.d("Flutter容器销毁")
    }
}
