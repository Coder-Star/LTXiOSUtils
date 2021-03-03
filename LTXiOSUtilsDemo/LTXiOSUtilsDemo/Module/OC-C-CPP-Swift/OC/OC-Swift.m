//
//  OC-Swift.m
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/8/20.
//  Copyright © 2020 李天星. All rights reserved.
//

#import "OC-Swift.h"
// 这个LTXiOSUtilsDemo为Product Name是在Build Settings 可以看到
#import "LTXiOSUtilsDemo-Swift.h"

@implementation OC_Swift

- (void)testOC {
    printf("OC被调用");
}

- (void)testSwift {
    OCSwiftClassOCName *oc = [OCSwiftClassOCName alloc];
    [oc show];
}

@end
