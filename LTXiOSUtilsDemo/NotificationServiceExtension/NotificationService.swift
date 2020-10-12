//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by 李天星 on 2020/10/9.
//  Copyright © 2020 李天星. All rights reserved.
//

/**
 ServiceExtension目前只对远程通知生效，可以让我们有机会在收到远程推送通知后，展示之前对通知内容进行修改，APP在后台、前台以及被杀死都会执行

 原生推送必须设置 mutable-content = 1

 使用场景
 1、可以实现push到达率统计功能
 2、可以实现不启动APP，下载小文件功能
 3、可以进行push信息脱敏处理功能
 4、可以更改提示音功能

 */

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    /// 在后台处理接收到的推送，传递最终的内容给contentHandler，处理时间不要太长，30秒
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {

            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"

            // TAPNs统计上报
            XGExtension.defaultManager().reportDomainName = "tpns.sh.tencent.com"
            XGExtension.defaultManager().handle(request, accessID: 1680001375, accessKey: "IYBJPGFD2RRO") { attachments, error in
                print(error)
                if let attachments = attachments {
                    bestAttemptContent.attachments = attachments
                }
                contentHandler(bestAttemptContent)
            }


            // 原生显示附件图片
//            if let customData = (bestAttemptContent.userInfo["custom"] as? String)?.data(using: .utf8), let custom = try? JSONSerialization.jsonObject(with: customData, options: .allowFragments) as? [String: String] {
//                if let imageUrlStr = custom["image_url"], let imageUrl = URL(string: imageUrlStr) {
//                    print(imageUrl)
//                    downloadAndSave(url: imageUrl) { localURL in
//                        if let localURL = localURL {
//                            do {
//                                // 这个url需要是一个本地文件file路径
//                                let attachment = try UNNotificationAttachment(identifier: "download", url: localURL, options: nil)
//                                bestAttemptContent.attachments = [attachment]
//                            } catch {
//                                print(error)
//                            }
//                        }
//                        contentHandler(bestAttemptContent)
//                    }
//                }
//            }

        }

    }

    /// 在一小段的运行时间即将结束的时候，如果没有仍然没有成功的传入内容，会走到该方法
    /// 可以在该方法中设置肯定不会出错的内容或者传递默认内容
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

extension NotificationService {
    private func downloadAndSave(url: URL, handler: @escaping (_ localURL: URL?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, res, error in
            var localURL: URL? = nil
            if let data = data {
                //取得当前时间的时间戳
                let timeInterval = Date().timeIntervalSince1970
                let timeStamp = Int(timeInterval)
                //文件后缀
                let ext = (url.absoluteString as NSString).pathExtension
                let temporaryURL = FileManager.default.temporaryDirectory
                let url = temporaryURL.appendingPathComponent("\(timeStamp)")
                    .appendingPathExtension(ext)

                if let _ = try? data.write(to: url) {
                    localURL = url
                }
            }
            handler(localURL)
        })
        task.resume()
    }
}
