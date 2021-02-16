//
//  TestOCError.m
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/11/8.
//  Copyright © 2020 李天星. All rights reserved.
//

#import "TestOCError.h"

@implementation TestOCError

+ (void)testArrayIndexOutOfExpection {
    NSArray *a = [[NSArray alloc] init];
    NSLog(@"%@",a[10]);
}

@end
