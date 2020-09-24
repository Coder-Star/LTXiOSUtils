//
//  StoryboardSecondViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/23.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils

class StoryboardSecondViewController: BaseViewController {

    var infoFromPreviousViewController = ""

    @IBAction func backTo(_ sender: Any) {
        performSegue(withIdentifier: "backToStoryboardMainViewControllerSegue", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.d(tabBarItem.title)
        Log.d(navigationItem.title)
        Log.d("StoryboardSecondViewController")
        Log.d(infoFromPreviousViewController)
    }
}
