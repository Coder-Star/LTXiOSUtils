//
//  HUDDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2019/12/16.
//  Copyright © 2019 李天星. All rights reserved.
//

import Foundation

class HUDDemoViewController: BaseGroupTableMenuViewController {
    var hud: HUD?
    var progresss: Float = 0
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HUD"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "text", title: "文本"),
            BaseGroupTableMenuModel(code: "wait", title: "菊花框"),
            BaseGroupTableMenuModel(code: "progress", title: "横向进度条")
        ]
        menu.append(fisrtMenu)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = .none
        return cell
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "text":
            HUD.showText("这是一段很长很长很长很长很长很长很长很长很长很长很长很长的文本")
        case "wait":
            HUD.showWait()
            DispatchQueue.main.tx.delay(1) {
                HUD.hide()
            }
        case "progress":
            hud = HUD.showProgress(title: "开始加载")

            // 注意使用了WeakProxy，防止无法进入到deinit
            timer = Timer.scheduledTimer(timeInterval: 1, target: WeakProxy.proxy(with: self), selector: #selector(updateProgress(_:)), userInfo: ["info": "111"], repeats: true)

            // 手动触发一次
            timer?.fire()
        default:
            HUD.showText("暂无此模块")
        }
    }

    @objc
    func updateProgress(_ timer: Timer) {
        Log.d(timer.userInfo)
        progresss += 0.1
        hud?.updateProgress(progress: progresss, title: "当前进度:\(String(format: "%.2f", progresss))", successTitle: "完成")
    }

    deinit {
        Log.d("销毁")
        timer?.invalidate()
    }
}

class WeakProxy: NSObject {
    private weak var target: NSObjectProtocol?

    public init(_ target: NSObjectProtocol?) {
        self.target = target
        super.init()
    }

    public class func proxy(with target: NSObjectProtocol?) -> WeakProxy {
        return WeakProxy(target)
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        Log.d(aSelector)
        if target?.responds(to: aSelector) == true {
            return target
        } else {
            return super.forwardingTarget(for: aSelector)
        }
    }

    override func responds(to aSelector: Selector!) -> Bool {
        Log.d(aSelector)
        return target?.responds(to: aSelector) == true
    }

    override func conforms(to aProtocol: Protocol) -> Bool {
        return target?.conforms(to: aProtocol) == true
    }

    override func isEqual(_ object: Any?) -> Bool {
        return target?.isEqual(object) == true
    }

    override var superclass: AnyClass? {
        return target?.superclass
    }

    override func isKind(of aClass: AnyClass) -> Bool {
        return target?.isKind(of: aClass) == true
    }

    override func isMember(of aClass: AnyClass) -> Bool {
        return target?.isMember(of: aClass) == true
    }

    override var description: String {
        return target?.description ?? ""
    }

    override var debugDescription: String {
        return target?.debugDescription ?? ""
    }
}
