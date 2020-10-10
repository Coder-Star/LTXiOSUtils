//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by 李天星 on 2020/10/9.
//  Copyright © 2020 李天星. All rights reserved.
//

/**
 ServiceExtension目前只对远程通知生效，可以让我们有机会在收到远程推送通知后，展示之前对通知内容进行修改
 通过本机截取推送并替换内容的方式，我们可以实现推送加密，对于一些聊天，金融类APP是必要的

 原生推送必须设置 mutable-content = 1
 */

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    /// 在后台处理接收到的推送，传递最终的内容给contentHandler，处理时间不要太长，
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            if let customData = (bestAttemptContent.userInfo["custom"] as? String)?.data(using: .utf8), let custom = try? JSONSerialization.jsonObject(with: customData, options: .allowFragments) as? [String: String] {
                if let imageUrlStr = custom["image_url"], let imageUrl = URL(string: imageUrlStr) {
                    print(imageUrl)
                    downloadAndSave(url: imageUrl) { localURL in
                        if let localURL = localURL {
                            do {
                                // 这个url需要是一个本地文件file路径
                                let attachment = try UNNotificationAttachment(identifier: "download", url: localURL, options: nil)
                                bestAttemptContent.attachments = [attachment]
                            } catch {
                                print(error)
                            }
                        }
                        contentHandler(bestAttemptContent)
                    }
                }
            }
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
