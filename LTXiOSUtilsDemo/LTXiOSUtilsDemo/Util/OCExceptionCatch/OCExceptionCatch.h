//
//  OCExceptionCatch.h
//  LTXiOSUtilsDemo
//  捕获OC的异常
//  Created by 李天星 on 2020/11/10.
//  Copyright © 2020 com.topscommmac01. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCExceptionCatch : NSObject

/**
 Swift端示例代码
 do {
     try OCExceptionCatch.catchException {

     }
 } catch let error {

 }
*/

/// 捕获OC的异常
/// @param tryBlock Swift部分需要执行的代码
/// @param error 产生的错误
+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end

NS_ASSUME_NONNULL_END
