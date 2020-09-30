//
//  XGFreeInteraction.h
//  和TPNS免费版(信鸽)的交互，方便免费版用户迁移到腾讯云TPNS
//
//  Created by xiang on 2020/2/26.
//  Copyright © 2020 XG of Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 免费集群accessId,在反注册设备时会用到，防止两边同时推送出现重，免费集群url: https://xg.qq.com
@interface XGForFreeVersion : NSObject
/// accessid for free version
@property uint32_t freeAccessId;
/// share instance
+ (instancetype)defaultForFreeVersion;

@end
