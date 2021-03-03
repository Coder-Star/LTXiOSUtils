//
//  NSObject+TestCPPWrapper.m
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2021/3/3.
//  Copyright © 2021 李天星. All rights reserved.
//

#import "TestCPPWrapper.h"

// C++文件头
#import "TestCPP.hpp"

@implementation TestCPPWrapper

- (void)testCPP {
    TestCPP *testCPP = new TestCPP();
    testCPP->testVoid();
}

@end
