//
//  XGPushPrivate.h
//  TPNS-SDK
//
//  Created by uwei on 2019/1/23.
//  Copyright © 2019 mta. All rights reserved.
//

#ifndef XGPushPrivate_h
#define XGPushPrivate_h

#import "XGPush.h"

@interface XGPush (XGPushPrivate)

- (void)configureHost:(NSString *)host port:(NSInteger)port;

- (void)configureStatReportHost:(NSString *)host port:(NSInteger)port;

@end

#endif /* XGPushPrivate_h */
