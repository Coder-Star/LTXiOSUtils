//
//  OperationTestViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/7/29.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils

class OperationTestViewController: BaseUIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "OperationTest"

        let array1 = NSMutableArray()
        let array2 = NSMutableArray()
        array1.add(array2)
        array2.add(array1)
    }
}
