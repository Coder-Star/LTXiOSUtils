//
//  LameUtilDelegate.h
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/8/20.
//  Copyright © 2020 李天星. All rights reserved.
//

@protocol LameUtilDelegate <NSObject>

/**
 * 获取结束标志位
 */
@optional
- (bool)getEndSign;

/**
 * 转换完成
 */
@optional
- (void)convertFinish:(NSString *)audioFilePath mp3Path:(NSString *) mp3Path;

/**
 * 转换出现错误
 */
@optional
- (void)convertError:(NSString *)message;

@end
