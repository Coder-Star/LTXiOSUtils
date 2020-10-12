//
//  SlideAdressTool.m
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/10/12.
//  Copyright © 2019年 李天星. All rights reserved.
//

#import "SlideAdressTool.h"
#import <mach-o/dyld.h>

@implementation SlideAdressTool

long calculate(void) {
    long slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
            slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    return slide;
}

@end
