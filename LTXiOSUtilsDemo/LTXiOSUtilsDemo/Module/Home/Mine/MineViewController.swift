//
//  MineViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/15.
//  Copyright © 2020 李天星. All rights reserved.
//

import UIKit
import LTXiOSUtils

class MineViewController: BaseUIViewController {

    @IBOutlet weak var headerIconImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.d(headerIconImageView)
        headerIconImageView.image = R.image.xib_header_dog()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        Log.d(headerIconImageView)
    }

}
