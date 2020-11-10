//
//  OCExceptionCatch.m
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/11/10.
//  Copyright © 2020 com.topscommmac01. All rights reserved.
//

#import "OCExceptionCatch.h"

@implementation OCExceptionCatch

+ (BOOL)catchException:(void (^)(void))tryBlock error:(NSError *__autoreleasing  _Nullable *)error {
    @try {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception) {
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
        return NO;
    }
}

@end
