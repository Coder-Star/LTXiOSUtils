//
//  XGPushStatMTA.h
//  XGPushStatMTA-SDK
//
//  Originally Created by uweiyuan on 2019/7/4.
//
//

#import <Foundation/Foundation.h>

/**
 XGPushStatMTA版本号
 */

#define MTA_SDK_VERSION @"2.5.4"

#pragma mark - 接口监控相关数据结构
/**
 接口统计的枚举值
 */
typedef enum {
    /**
     接口调用成功
     */
    XGPushStatMTA_SUCCESS = 0,

    /**
     接口调用失败
     */
    XGPushStatMTA_FAILURE = 1,

    /**
     接口调用出现逻辑错误
     */
    XGPushStatMTA_LOGIC_FAILURE = 2
} XGPushStatMTAAppMonitorErrorType;

/**
 XGPushStatMTA错误码

 - XGPushStatEC_OK: 无错误
 - XGPushStatEC_SERVICE_DISABLE: XGPushStatMTA服务未启动，请检查是否调用[XGPushStatMTA startWithAppkey:]
 - XGPushStatEC_ARGUMENT_INVALID: 参数错误，比如eventID为空，或者在没有结束计时事件的情况下又重新开始计时事件
 - XGPushStatEC_INPUT_LENGTH_LIMIT: 参数过长，详细情况请查看自定义事件API的注释
 */
typedef NS_ENUM(NSInteger, XGPushStatMTAErrorCode) {
    XGPushStatEC_OK = 0,
    XGPushStatEC_SERVICE_DISABLE = -1,
    XGPushStatEC_ARGUMENT_INVALID = 1000,
    XGPushStatEC_INPUT_LENGTH_LIMIT = 1001,
};

#pragma mark - XGPushStatMTA统计功能相关接口
@interface XGPushStatMTA : NSObject

#pragma mark - 启动XGPushStatMTA

/**
 启动XGPushStatMTA

 @param appkey 从网页申请的appKey
 */
+ (void)startWithAppkey:(NSString *)appkey;

/**
 检测版本，并启动XGPushStatMTA。
 如果当前XGPushStatMTA的版本小于ver参数，则XGPushStatMTA不启动。否则启动XGPushStatMTA。

 @param appkey 从网页申请的appKey
 @param ver 最低允许启动的版本
 @return 如果XGPushStatMTA成功启动，返回YES，否则返回NO
 */
+ (BOOL)startWithAppkey:(NSString *)appkey checkedSdkVersion:(NSString *)ver;

#pragma mark - XG
+ (XGPushStatMTAErrorCode)reportMessageInfo:(NSDictionary *)info;

+ (XGPushStatMTAErrorCode)reportErrInfo:(NSDictionary *)info;

@end
