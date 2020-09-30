//
//  TPNSInAppMessageActionProtocol.h
//  TPNSInAppMessage
//
//  Created by zq on 2020/8/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#ifndef TPNSInAppMessageActionProtocol_h
#define TPNSInAppMessageActionProtocol_h


#endif /* TPNSInAppMessageActionProtocol_h */

#import <Foundation/Foundation.h>

/// TPNSInAppMessage事件代理
@protocol TPNSInAppMessageActionDelegate <NSObject>

@optional
/// 通过下发的自定义参数去做响应
/// @param actionName 自定义事件字符串标识
- (void)onClickWithCustomAction:(NSString *)actionName;

@end
