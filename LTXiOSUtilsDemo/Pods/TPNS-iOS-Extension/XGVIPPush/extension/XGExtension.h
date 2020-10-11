//
//  XGExtension.h
//  XGExtension
//
//  Created by uwei on 28/11/2017.
//  Copyright © 2017 TEG of Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

#if TARGET_OS_IPHONE
#define kExtensionSDKVersion @"1.2.8.0"
#elif TARGET_OS_MAC
#define kExtensionSDKVersion @"1.0.4.0"
#endif

NS_AVAILABLE(10_14, 10_0)
@interface XGExtension : NSObject

/**
自定义配置上报消息抵达的服务器的二级域名
@note 默认广州集群，例如tpns.sgp.tencent.com代表新加坡集群, tpns.hk.tencent.com代表香港集群，等等。
*/
@property (nonatomic, copy, nullable) NSString *reportDomainName;
@property (nonatomic, copy, nullable) NSString *reportHost __deprecated_msg("You should use reportDomainName instead");

/// 是否开启替换重复消息，default
/// NO；如果设置为YES，则需要同时根据实际情况设置属性defaultTitle、defaultSubtitle、defaultContent的值；重复消息替换只支持最新的两条消息之间的替换
@property BOOL isDeduplication;

/// 当收到重复消息时用来替换的消息标题，默认是被替换消息的标题
@property (nonatomic, copy, nonnull) NSString *defaultTitle;

/// 当收到重复消息时用来替换的消息副标题，默认是被替换消息的副标题
@property (nonatomic, copy, nonnull) NSString *defaultSubtitle;

/// 当收到重复消息时用来替换的消息内容，内容长度必须要大于1个字符，默认是被替换消息的内容
@property (nonatomic, copy, nonnull) NSString *defaultContent;

/// 当收到重复消息时用来替换的消息参数，默认是被替换消息参数
@property (nonatomic, copy, nonnull) NSDictionary *defaultUserInfo;

/**
 @brief TPNS Service extension管理对象

 @return 管理对象
 */
+ (nonnull instancetype)defaultManager;

/**
 @brief TPNS处理抵达到终端的消息，即消息回执

 @param request 推送请求
 @param accessID TPNS应用 accessId
 @param accessKey TPNS应用 accessKey
 @param handler 处理消息的回调，回调方法中处理关联的富媒体文件
 */
- (void)handleNotificationRequest:(nonnull UNNotificationRequest *)request
                         accessID:(uint32_t)accessID
                        accessKey:(nonnull NSString *)accessKey
                   contentHandler:(nullable void (^)(NSArray<UNNotificationAttachment *> *_Nullable attachments, NSError *_Nullable error))handler;

/**
 @brief TPNS处理抵达到终端的消息，即消息回执

 @param request 推送请求
 @param key 包含有富媒体文件的字段
 @param accessID TPNS应用 accessId
 @param accessKey TPNS应用 accessKey
 @param handler 处理消息的回调，回调方法中处理关联的富媒体文件
 */
- (void)handleNotificationRequest:(nonnull UNNotificationRequest *)request
                    attachmentKey:(nonnull NSString *)key
                         accessID:(uint32_t)accessID
                        accessKey:(nonnull NSString *)accessKey
                   contentHandler:(nullable void (^)(NSArray<UNNotificationAttachment *> *_Nullable attachments, NSError *_Nullable error))handler;

/**
 @brief 下载富媒体推送的文件并转换为通知中的附件

 @param url 富媒体文件URL
 @param completionHandler 结果回调，在其中包含富媒体转换为附件的结果
 */
- (void)startDownloadAttachmentFromURL:(nonnull NSString *)url
                     completionHandler:(nullable void (^)(UNNotificationAttachment *_Nullable attachment, NSError *_Nullable error))completionHandler;

/// TPNS处理抵达到终端的消息，即消息回执，支持重复内容替换。需要开启
/// isDeduplication，同时根据需要设置替换消息属性字段defaultTitle、defaultSubtitle、defaultContent的值
/// @param request 推送请求
/// @param accessID TPNS应用 accessId
/// @param accessKey TPNS应用 accessKey
/// @param handler  替换重复消息的回调
- (void)handleNotificationRequest:(nonnull UNNotificationRequest *)request
                         accessID:(uint32_t)accessID
                        accessKey:(nonnull NSString *)accessKey
            replaceContentHandler:(nullable void (^)(UNNotificationContent *_Nullable, NSError *_Nullable, BOOL))handler;

@end
