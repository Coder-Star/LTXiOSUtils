//
//  XGLocalNotification.h
//  XG-SDK
//
//  Created by rockzuo on 2020/10/27.
//  Copyright © 2020 TEG of Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 通知内容类
@interface XGNotificationContent : NSObject <NSCopying>

/// 通知标题
@property (nonatomic, copy) NSString *title;
/// 通知副标题
@property (nonatomic, copy) NSString *subtitle;
/// 通知内容
@property (nonatomic, copy) NSString *body;
/// 通知角标,不需要修改则不传
@property (nonatomic, copy) NSNumber *badge;
/// 自定义弹框按钮显示的内容
@property (nonatomic, copy) NSString *action NS_DEPRECATED_IOS(8_0, 10_0);
/// 分类标识
@property (nonatomic, copy) NSString *categoryIdentifier;
/// 本地推送时可以通过userInfo设置附加信息
@property (nonatomic, copy) NSDictionary *userInfo;
/// 收到通知提示音，不设置则为默认声音（您可以本地使用一段声音，创建本地通知时指定此声音）
@property (nonatomic, copy) NSString *sound;
/// 图片、音视频富媒体元素url地址，具体类型支持请参考：https://cloud.tencent.com/document/product/548/46964
@property (nonatomic, copy) NSString *mediaUrl;
/// 线程或与推送请求相关对话的标识，可用来对推送进行分组
@property (nonatomic, copy) NSString *threadIdentifier NS_AVAILABLE_IOS(10_0);
/// 启动图片
@property (nonatomic, copy) NSString *launchImageName NS_AVAILABLE_IOS(10_0);

@end

/// 通知触发类
@interface XGNotificationTrigger : NSObject <NSCopying>

/// 是否重复，默认值NO
@property (nonatomic, assign) BOOL repeats;
/// 推送触发时间，低于iOS10使用
@property (nonatomic, copy) NSDate *fireDate NS_DEPRECATED_IOS(2_0, 10_0);
/// 推送触发时间，iOS10+使用，优先级I(dateComponents和timeInterval都有值时优先使用dateComponents)
@property (nonatomic, copy) NSDateComponents *dateComponents NS_AVAILABLE_IOS(10_0);
/// 推送触发时间，iOS10+使用，优先级II(dateComponents和timeInterval都有值时优先使用dateComponents)
/// 当repeats为YES时timeInterval时间间隔必须大于60S
@property (nonatomic, assign) NSTimeInterval timeInterval NS_AVAILABLE_IOS(10_0);

@end

/// 通知管理类
@interface XGNotificationRequest : NSObject <NSCopying>

/// 通知请求标识，移除通知会用到此标识
@property (nonatomic, copy) NSString *requestIdentifier;
/// 通知内容
@property (nonatomic, copy) XGNotificationContent *content;
/// 通知触发器
@property (nonatomic, copy) XGNotificationTrigger *trigger;

@end

/// 通知类
@interface XGLocalNotification : NSObject

/// 注册或更新推送
/// @param request XGNotificationRequest类型，管理推送相关属性
/// @note iOS10+支持在已有推送基础上设置request.requestIdentifier来更新此推送
+ (void)addNotification:(XGNotificationRequest *)request;

/// 获取计划发送的通知
/// @param completionHandler 计划发送通知回调，iOS10+返回UNNotificationRequest数组，低于iOS10返回UILocalNotification数组
+ (void)getPendingNotificationRequestsWithCompletionHandler:(void (^)(NSArray *requests))completionHandler;

/// 移除计划发送的通知
/// @param identifiers 要移除的本地推送标识的集合
+ (void)removePendingLocalNotification:(NSArray<NSString *> *)identifiers;

/// 移除所有计划发送的通知
+ (void)removeAllPendingLocalNotifications;

@end
