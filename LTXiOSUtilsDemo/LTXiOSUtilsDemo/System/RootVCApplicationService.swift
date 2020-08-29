//
//  RootVCApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/1/9.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import XHLaunchAd
import LTXiOSUtils

final class RootVCApplicationService: NSObject, ApplicationService {

    // 定义成全局，使其被强引用，避免释放，释放就不显示
    var secondWindow: UIWindow?

    private let showAd = false //是否启用广告
    let showGuide = false //是否启用引导页

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        /// 当APP处于死亡状态，收到推送、点击推送消息启动APP，可以通过下面的方式获取到推送消息
        let pushInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
//        Log.d(pushInfo)

        window?.makeKeyAndVisible()

        if showAd {
            setLaunchAd()
        }

        if !showGuide {
            setNormalRootViewController()
        } else {

        }

        // 等待rootview加载完成
//        self.perform(#selector(setSecondWindow), with: nil, afterDelay: 0.5)

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

extension RootVCApplicationService: XHLaunchAdDelegate {
    /// 设置开屏广告
    private func setLaunchAd() {
        XHLaunchAd.setLaunch(.launchScreen)
        XHLaunchAd.setWaitDataDuration(1) //如果这段时间没有取得json，就会直接跳过广告
        var requestParam = RequestParam(baseUrl: NetworkConstant.appUrl, path: NetworkConstant.launchAdData)
        requestParam.method = .get
        requestParam.hud.isShow = false
        NetworkManager.sendRequest(requestParam: requestParam, success: { data in
            let json = JSON(data)
            Log.d(json)
            if let adModel = AdModel(JSONString: json.description) {
                let config = XHLaunchImageAdConfiguration()
                config.duration = adModel.duration!
                config.skipButtonType = adModel.skipBtnType!
                config.imageNameOrURLString = adModel.imgUrl!
                config.imageOption = .cacheInBackground
                config.showFinishAnimate = adModel.animationType!
                config.openModel = adModel.actionUrl!
                XHLaunchAd.imageAd(with: config, delegate: self)
            }
        }, failure: { _ in
            Log.d(XHLaunchAd.cacheImageURLString())
            let url = XHLaunchAd.cacheImageURLString()
            if url.tx.isNotEmpty {
                let config = XHLaunchImageAdConfiguration()
                config.duration = 5
                config.skipButtonType = .timeText
                config.imageNameOrURLString = url
                config.imageOption = .cacheInBackground
                config.showFinishAnimate = .fadein
                XHLaunchAd.imageAd(with: config)
            }
        })
    }

    func xhLaunchAd(_ launchAd: XHLaunchAd, clickAtOpenModel openModel: Any, click clickPoint: CGPoint) -> Bool {
        Log.d(openModel)
        return true
    }
}

extension RootVCApplicationService {
    func go() {
        setNormalRootViewController()
        Log.d(showAd)
    }
}
