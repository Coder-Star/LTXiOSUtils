//
//  ViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/8/2.
//  Copyright © 2019年 李天星. All rights reserved.
//

import UIKit
class ViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.menu()
    }
    //ConstantsEnum
    override func setMenu() {
        let fisrtMenu = [
            [ConstantsEnum.title:"第一个功能",ConstantsEnum.image:"123",ConstantsEnum.code:"123"]
        ]
        menu.append(fisrtMenu)
    }

    override func click(code: String) {
       HUD.show("这是一个很长很长很长很长很长很长很长很长很长很长很长很长")
    }
}
