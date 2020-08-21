//
//  LameUtil.h
//  LTXiOSUtilsDemo
//  录音出来的文件转为mp3格式
//  Created by 李天星 on 2020/8/20.
//  Copyright © 2020 李天星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LameUtilDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LameUtil: NSObject


/// 将pcm格式转mp3格式，边录边转
/// @param audioFilePath 源文件路径
/// @param mp3FilePath 转完的mp3文件路径
/// @param delegate 代理
+ (void) convertWhenRecordingFrom:(NSString *)audioFilePath mp3File:(NSString *)mp3FilePath delegate:(id<LameUtilDelegate>) delegate;

/// 将pcm格式转mp3格式，全录完再转
/// @param audioFilePath 源文件路径
/// @param mp3FilePath 转完的mp3文件路径
/// @param delegate 代理
+ (void) convertWhenRecordedFrom:(NSString *)audioFilePath mp3File:(NSString *)mp3FilePath delegate:(id<LameUtilDelegate>) delegate;


@end

NS_ASSUME_NONNULL_END
