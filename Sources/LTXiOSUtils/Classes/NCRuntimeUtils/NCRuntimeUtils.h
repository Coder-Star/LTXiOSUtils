//
//  NCRuntimeUtils.h
//  NCModuleManager
//
//  Created by CoderStar on 2022/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN BOOL canEnumerateClassesInImage(void);

FOUNDATION_EXTERN void enumerateClassesInMainBundle(void(^handler)(__unsafe_unretained Class aClass));

NS_ASSUME_NONNULL_END
