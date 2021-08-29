//
//  ViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2021/8/9.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        Log.d(ClassUtils.subclasses(of: XXX.self))
        Log.d("11")
    }
}

class XXX {}

class YYY: XXX {}
