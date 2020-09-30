//
//  TPNSInAppMessageManager.h
//  TPNSInAppMessage
//
//  Created by zq on 2020/8/17.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TPNSInAppMessageActionProtocol.h"

/// 消息管理类
@interface TPNSInAppMessageManager : NSObject

/// 图片资源Bundle名
@property (nonatomic, copy, nullable) NSBundle *resourceBundle;

/// 按钮事件响应代理
@property (weak, nonatomic, nullable) id<TPNSInAppMessageActionDelegate> actionDelegate;

/// 设置消息展示的window
@property (strong, nonatomic, nullable) UIWindow *targetWindow;

/// 单例方法
+ (nonnull instancetype)sharedManager;

/// 展示自定义消息
/// @param messageInfo 应用内消息结构
- (void)presentCustomMessage:(nullable NSDictionary *)messageInfo;

/// 关闭消息视图
- (void)dismissPopWindow;

@end

