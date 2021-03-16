//
//  OC-Swift.h
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/8/20.
//  Copyright © 2020 李天星. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

// 向前声明，OC一般在头文件相互引入时候用到，
// Swift中用到的场景是一个OC类内部使用了Swift的类，然后Swift又调用这个OC类，这个时候需要OC引入那个Swift的时候用向前声明的方式。
@class OCSwiftClassOCName;

NS_ASSUME_NONNULL_BEGIN

@interface OC_Swift : NSObject

- (void) testOC;

- (void) testSwift;

@end

NS_ASSUME_NONNULL_END
