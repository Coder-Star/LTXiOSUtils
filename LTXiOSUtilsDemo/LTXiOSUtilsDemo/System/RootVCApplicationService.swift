//
//  RootVCApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/1/9.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
//import XHLaunchAd
import LTXiOSUtils
import AppOrderFiles

final class RootVCApplicationService: NSObject, ApplicationService {

    // 定义成全局，使其被强引用，避免释放，释放就不显示
    var secondWindow: UIWindow?

    private let showAd = false //是否启用广告
    let showGuide = false //是否启用引导页

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // 获取order文件路径
        AppOrderFiles { orderFilePath in
            Log.d(orderFilePath)

        }

        window?.makeKeyAndVisible()

        if showAd {
//            setLaunchAd()
        }

        if !showGuide {
            setNormalRootViewController()
        } else {

        }

        // 等待rootview加载完成
//        self.perform(#selector(setSecondWindow), with: nil, afterDelay: 0.5)
//        launchAnimation()
        return true
    }

    private func setNormalRootViewController() {
        let rootViewController = HomeTabBarController()
        window?.rootViewController = rootViewController
    }

    @objc
    private func setSecondWindow() {
        Log.d("显示第二个Window")
        secondWindow = UIWindow()
        secondWindow?.frame = CGRect(x: 10, y: 500, width: 50, height: 50)
        secondWindow?.backgroundColor = .red
        secondWindow?.windowLevel = UIWindow.Level.alert + 1
        secondWindow?.makeKeyAndVisible()
    }
}

extension RootVCApplicationService {
    // 播放启动画面动画
    private func launchAnimation() {
        let vc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        guard let launchview = vc?.view else {
            return
        }
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        window!.addSubview(launchview)
        UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {
            let transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
            launchview.layer.transform = transform
        }, completion: { _ in
            launchview.removeFromSuperview()
        })
    }
}

//extension RootVCApplicationService: XHLaunchAdDelegate {
//    /// 设置开屏广告
//    private func setLaunchAd() {
//        XHLaunchAd.setLaunch(.launchScreen)
//        XHLaunchAd.setWaitDataDuration(1) //如果这段时间没有取得json，就会直接跳过广告
//        var requestParam = RequestParam(path: NetworkConstant.launchAdData)
//        requestParam.method = .get
//        requestParam.hud.isShow = false
//        NetworkManager.sendRequest(requestParam: requestParam, success: { data in
//            let json = JSON(data)
//            Log.d(json)
//            if let adModel = AdModel(JSONString: json.description) {
//                let config = XHLaunchImageAdConfiguration()
//                config.duration = adModel.duration!
//                config.skipButtonType = adModel.skipBtnType!
//                config.imageNameOrURLString = adModel.imgUrl!
//                config.imageOption = .cacheInBackground
//                config.showFinishAnimate = adModel.animationType!
//                config.openModel = adModel.actionUrl!
//                XHLaunchAd.imageAd(with: config, delegate: self)
//            }
//        }, failure: { _ in
//            Log.d(XHLaunchAd.cacheImageURLString())
//            let url = XHLaunchAd.cacheImageURLString()
//            if url.tx.isNotEmpty {
//                let config = XHLaunchImageAdConfiguration()
//                config.duration = 5
//                config.skipButtonType = .timeText
//                config.imageNameOrURLString = url
//                config.imageOption = .cacheInBackground
//                config.showFinishAnimate = .fadein
//                XHLaunchAd.imageAd(with: config)
//            }
//        })
//    }
//
//    func xhLaunchAd(_ launchAd: XHLaunchAd, clickAtOpenModel openModel: Any, click clickPoint: CGPoint) -> Bool {
//        Log.d(openModel)
//        return true
//    }
//}
