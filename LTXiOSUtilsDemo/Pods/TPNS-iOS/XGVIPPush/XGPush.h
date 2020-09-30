//
//  TPNS核心接口
//  TPNS-SDK
//
//  Created by xiangchen on 13-10-18.
//  Update by uweiyuan on 4/08/17.
//  Copyright (c) 2019 TEG of Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 101400
#import <UserNotifications/UserNotifications.h>
#endif
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UserNotifications/UserNotifications.h>
#endif

@class CLLocation;

/**
 @brief 点击行为对象的属性配置

 - XGNotificationActionOptionNone: 无
 - XGNotificationActionOptionAuthenticationRequired: 需要认证的选项
 - XGNotificationActionOptionDestructive: 具有破坏意义的选项
 - XGNotificationActionOptionForeground: 打开应用的选项
 */
typedef NS_ENUM(NSUInteger, XGNotificationActionOptions) {
    XGNotificationActionOptionNone = (0),
    XGNotificationActionOptionAuthenticationRequired = (1 << 0),
    XGNotificationActionOptionDestructive = (1 << 1),
    XGNotificationActionOptionForeground = (1 << 2)
};

/**
 * @brief 定义了一个可以在通知栏中点击的事件对象
 */
@interface XGNotificationAction : NSObject

/**
 @brief 在通知消息中创建一个可以点击的事件行为

 @param identifier 行为唯一标识
 @param title 行为名称
 @param options 行为支持的选项
 @return 行为对象
 @note 通知栏带有点击事件的特性，只有在iOS 8+、macOS 10.14+ 以上支持，iOS 8、macOS10.14 or earlier的版本，此方法返回空
 */
+ (nullable id)actionWithIdentifier:(nonnull NSString *)identifier title:(nonnull NSString *)title options:(XGNotificationActionOptions)options;

/**
 @brief 点击行为的标识
 */
@property (nullable, nonatomic, copy, readonly) NSString *identifier;

/**
 @brief 点击行为的标题
 */
@property (nullable, nonatomic, copy, readonly) NSString *title;

/**
 @brief 点击行为的特性
 */
@property (readonly, nonatomic) XGNotificationActionOptions options;

@end

/**
 @brief 分类对象的属性配置

 - XGNotificationCategoryOptionNone: 无
 - XGNotificationCategoryOptionCustomDismissAction: 发送消失事件给UNUserNotificationCenter(iOS 10+、macOS 10.14+ or later)对象
 - XGNotificationCategoryOptionAllowInCarPlay: 允许CarPlay展示此类型的消息
 */
typedef NS_OPTIONS(NSUInteger, XGNotificationCategoryOptions) {
    XGNotificationCategoryOptionNone = (0),
    XGNotificationCategoryOptionCustomDismissAction = (1 << 0),
    XGNotificationCategoryOptionAllowInCarPlay = (1 << 1)
};

/**
 * 通知栏中消息指定的分类，分类主要用来管理一组关联的Action，以实现不同分类对应不同的Actions
 */
@interface XGNotificationCategory : NSObject

/**
 @brief 创建分类对象，用以管理通知栏的Action对象

 @param identifier 分类对象的标识
 @param actions 当前分类拥有的行为对象组
 @param intentIdentifiers 用以表明可以通过Siri识别的标识
 @param options 分类的特性
 @return 管理点击行为的分类对象
 @note 通知栏带有点击事件的特性，只有在iOS 8+ 、macOS 10.14+ 以上支持，iOS 8 、macOS 10.14  or earlier的版本，此方法返回空
 */
+ (nullable id)categoryWithIdentifier:(nonnull NSString *)identifier
                              actions:(nullable NSArray<id> *)actions
                    intentIdentifiers:(nullable NSArray<NSString *> *)intentIdentifiers
                              options:(XGNotificationCategoryOptions)options;

/**
 @brief 分类对象的标识
 */
@property (nonnull, readonly, copy, nonatomic) NSString *identifier;

/**
 @brief 分类对象拥有的点击行为组
 */
@property (nonnull, readonly, copy, nonatomic) NSArray<XGNotificationAction *> *actions;

/**
 @brief 可用以Siri意图的标识组
 */
@property (nullable, readonly, copy, nonatomic) NSArray<NSString *> *intentIdentifiers;

/**
 @brief 分类的特性
 */
@property (readonly, nonatomic) XGNotificationCategoryOptions options;

@end

/**
 @brief 注册通知支持的类型

 - XGUserNotificationTypeNone: 无
 - XGUserNotificationTypeBadge: 支持应用角标
 - XGUserNotificationTypeSound: 支持铃声
 - XGUserNotificationTypeAlert: 支持弹框
 - XGUserNotificationTypeCarPlay: 支持CarPlay,iOS 10.0+
 - XGUserNotificationTypeCriticalAlert: 支持紧急提醒播放声音, iOS 12.0+
 - XGUserNotificationTypeProvidesAppNotificationSettings: 让系统在应用内通知设置中显示按钮, iOS 12.0+
 - XGUserNotificationTypeProvisional: 能够将非中断通知临时发布到 Notification Center, iOS 12.0+
 - XGUserNotificationTypeNewsstandContentAvailability: 支持 Newsstand, iOS 3.0–8.0
 */
typedef NS_OPTIONS(NSUInteger, XGUserNotificationTypes) {
    XGUserNotificationTypeNone = (0),
    XGUserNotificationTypeBadge = (1 << 0),
    XGUserNotificationTypeSound = (1 << 1),
    XGUserNotificationTypeAlert = (1 << 2),
    XGUserNotificationTypeCarPlay = (1 << 3),
    XGUserNotificationTypeCriticalAlert = (1 << 4),
    XGUserNotificationTypeProvidesAppNotificationSettings = (1 << 5),
    XGUserNotificationTypeProvisional = (1 << 6),
    XGUserNotificationTypeNewsstandContentAvailability = (1 << 3)
};

/**
 @brief 管理推送消息通知栏的样式和特性
 */
@interface XGNotificationConfigure : NSObject

/**
 @brief 配置通知栏对象，主要是为了配置消息通知的样式和行为特性

 @param categories 通知栏中支持的分类集合
 @param types 注册通知的样式
 @return 配置对象
 */
+ (nullable instancetype)configureNotificationWithCategories:(nullable NSSet<id> *)categories types:(XGUserNotificationTypes)types;

- (nonnull instancetype)init NS_UNAVAILABLE;
/**
 @brief 返回消息通知栏配置对象
 */
@property (readonly, nullable, strong, nonatomic) NSSet<XGNotificationCategory *> *categories;

/**
 @brief 返回注册推送的样式类型
 */
@property (readonly, nonatomic) XGUserNotificationTypes types;

/**
 @brief 默认的注册推送的样式类型
 */
@property (readonly, nonatomic) XGUserNotificationTypes defaultTypes;

@end

/**
 @brief 设备token绑定的类型，绑定指定类型之后，就可以在TPNS前端按照指定的类型进行指定范围的推送

 - XGPushTokenBindTypeNone: 当前设备token不绑定任何类型，可以使用token单推，或者是全量推送（不推荐使用 ）
 - XGPushTokenBindTypeAccount: 当前设备token与账号绑定之后，可以使用账号推送
 - XGPushTokenBindTypeTag: 当前设备token与指定标签绑定之后，可以使用标签推送
 */
typedef NS_ENUM(NSUInteger, XGPushTokenBindType) {
    XGPushTokenBindTypeNone = (0),
    XGPushTokenBindTypeAccount = (1 << 0),
    XGPushTokenBindTypeTag = (1 << 1)
};

/**
 @brief 定义了一组关于设备token绑定，解绑账号和标签的回调方法，用以监控绑定和解绑的情况
 */
@protocol XGPushTokenManagerDelegate <NSObject>

@optional

/**
 @brief 监控token对象绑定的情况

 @param identifier token对象绑定的标识
 @param type token对象绑定的类型
 @param error token对象绑定的结果信息
 */
- (void)xgPushDidBindWithIdentifier:(nonnull NSString *)identifier type:(XGPushTokenBindType)type error:(nullable NSError *)error;

/**
 @brief 监控token对象解绑的情况

 @param identifier token对象解绑的标识
 @param type token对象解绑的类型
 @param error token对象解绑的结果信息
 */
- (void)xgPushDidUnbindWithIdentifier:(nonnull NSString *)identifier type:(XGPushTokenBindType)type error:(nullable NSError *)error;

/**
 @brief 监控token对象identifiers绑定的情况

 @param identifiers token对象绑定的标识
 @param type token对象绑定的类型
 @param error token对象绑定的结果信息
 */
- (void)xgPushDidBindWithIdentifiers:(nonnull NSArray *)identifiers type:(XGPushTokenBindType)type error:(nullable NSError *)error;

/**
 @brief 监控token对象identifiers解绑的情况

 @param identifiers token对象解绑的标识
 @param type token对象解绑的类型
 @param error token对象解绑的结果信息
 */
- (void)xgPushDidUnbindWithIdentifiers:(nonnull NSArray *)identifiers type:(XGPushTokenBindType)type error:(nullable NSError *)error;

/**
 @brief 监控token对象更新已绑定标识的情况

 @param identifiers token对象更新后的标识
 @param type token对象更新类型
 @param error token对象更新标识的结果信息
 */
- (void)xgPushDidUpdatedBindedIdentifiers:(nonnull NSArray *)identifiers bindType:(XGPushTokenBindType)type error:(nullable NSError *)error;

/**
 @brief 监控清除token对象绑定标识的情况

 @param type token对象清除的类型
 @param error token对象清除标识的结果信息
 */
- (void)xgPushDidClearAllIdentifiers:(XGPushTokenBindType)type error:(nullable NSError *)error;

@end

@interface XGPushTokenManager : NSObject

/**
 @brief 创建设备token的管理对象，用来管理token的绑定与解绑操作

 @return 设备token管理对象
 @note 此类的 APIs 调用都是以 Token 在TPNS服务上完成注册为前提
 */

+ (nonnull instancetype)defaultTokenManager;

- (nonnull instancetype)init NS_UNAVAILABLE;
/**
 @brief 设备token管理操作的代理对象
 */
@property (weak, nonatomic, nullable) id<XGPushTokenManagerDelegate> delegate;

/**
 @brief 返回当前设备token的字符串
 */
@property (copy, nonatomic, nullable, readonly) NSString *deviceTokenString;

/**
 @brief 返回当前TPNS 服务生成的token字符串
 */
@property (copy, nonatomic, nullable, readonly) NSString *xgTokenString;

/**
 @brief 为token对象设置绑定类型和标识

 @param identifier 指定绑定标识
 @param type 指定绑定类型
 @note 此接口应该在xgPushDidRegisteredDeviceToken:error:返回正确之后被调用
 @note 对于标签操作，标签字符串不允许有空格或者是tab字符
 @note 默认账号的类型是XGPushTokenAccountTypeUNKNOWN
 */
- (void)bindWithIdentifier:(nonnull NSString *)identifier
                      type:(XGPushTokenBindType)type __deprecated_msg("recommended to use bindWithIdentifiers:type:");

/**
 @brief 根据类型和标识为token对象解绑

 @param identifier 指定解绑标识
 @param type 指定解绑类型
 @note 此接口应该在xgPushDidRegisteredDeviceToken:error:返回正确之后被调用；若需要清除所有标识，建议使用 clearAllIdentifiers:
 @note 对于标签操作，标签字符串不允许有空格或者是tab字符
 @note 默认账号的类型是XGPushTokenAccountTypeUNKNOWN
 */
- (void)unbindWithIdentifer:(nonnull NSString *)identifier
                       type:(XGPushTokenBindType)type __deprecated_msg("recommended to use unbindWithIdentifers:type:");

/**
 @brief 根据指定类型查询当前token对象绑定的标识

 @param type 指定绑定类型
 @return 当前token对象绑定的标识
 */
- (nullable NSArray *)identifiersWithType:(XGPushTokenBindType)type;

/**
 @brief 为token对象设置绑定类型和标识

 @param identifiers 指定绑定标识，标签字符串不允许有空格或者是tab字符
 @param type 指定绑定类型
 @note 此接口应该在xgPushDidRegisteredDeviceToken:error:返回正确之后被调用
 @note 对于标签操作identifiers为标签字符串数组(标签字符串不允许有空格或者是tab字符)
 @note 对于账号操作，需要使用字典数组且key是固定要求，Objective-C的写法 : @[@{@"account":identifier, @"accountType":@(0)}]；
 Swift的写法：["account":identifier, "accountType":NSNumber(0)]
 @note 更多 accountType 请参照 XGPushTokenAccountType 枚举
 */
- (void)bindWithIdentifiers:(nonnull NSArray *)identifiers type:(XGPushTokenBindType)type;

/**
 @brief 根据类型和标识为token对象解绑

 @param identifiers 指定解绑标识，标签字符串不允许有空格或者是tab字符
 @param type 指定解绑类型
 @note 此接口应该在xgPushDidRegisteredDeviceToken:error:返回正确之后被调用；若需要清除所有标识，建议使用 clearAllIdentifiers:；
 @note 对于标签操作identifiers为标签字符串数组(标签字符串不允许有空格或者是tab字符)
 @note 对于账号操作，需要使用字典数组且key是固定要求，Objective-C的写法 : @[@{@"account":identifier, @"accountType":@(0)}]；
 Swift的写法：["account":identifier, "accountType":NSNumber(0)]
 @note 更多 accountType 请参照 XGPushTokenAccountType 枚举
 */
- (void)unbindWithIdentifers:(nonnull NSArray *)identifiers type:(XGPushTokenBindType)type;

/**
 @brief 根据类型，覆盖原有的标识；若之前没有绑定标识，则会执行新增标识

 @param identifiers 标签标识字符串数组，标签字符串不允许有空格或者是tab字符
 @param type 标识类型
 @note 此接口应该在xgPushDidRegisteredDeviceToken:error:返回正确之后被调用
 @note 对于标签操作，标签字符串不允许有空格或者是tab字符
 @note 对于账号操作，需要使用字典数组且key是固定要求，Objective-C的写法 : @[@{@"account":identifier, @"accountType":@(0)}]；
 Swift的写法：["account":identifier, "accountType":NSNumber(0)]
 @note 更多 accountType 请参照 XGPushTokenAccountType 枚举
 */
- (void)updateBindedIdentifiers:(nonnull NSArray *)identifiers bindType:(XGPushTokenBindType)type;

/**
 @brief 根据标识类型，清除所有标识

 @param type 标识类型
 @note 此接口应该在xgPushDidRegisteredDeviceToken:error:返回正确之后被调用
 */
- (void)clearAllIdentifiers:(XGPushTokenBindType)type;

@end

/**
 @brief 监控TPNS服务启动和设备token注册的一组方法
 */
@protocol XGPushDelegate <NSObject>

@optional
/**
 @brief 统一消息出口，此接口对不同操作系统版本的消息接口进行了封装

 @param notification 通知内容，需要根据返回类型来确定
 @param completionHandler 接收到消息的回调，必须要调用
 @note 自建通道消息也会通过此回调转发给应用侧使用，自建通道消息体结构与APNs通知消息体结构相同
 */
- (void)xgPushDidReceiveRemoteNotification:(nonnull id)notification withCompletionHandler:(nullable void (^)(NSUInteger))completionHandler;

/**
  @brief 处理iOS 10、macOS10.14 UNUserNotification.framework的对应的方法

 @param center [UNUserNotificationCenter currentNotificationCenter]
 @param notification 通知对象
 @param completionHandler 回调对象，必须调用
 */
- (void)xgPushUserNotificationCenter:(nonnull UNUserNotificationCenter *)center
             willPresentNotification:(nullable UNNotification *)notification
               withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0)
                                         __OSX_AVAILABLE(10.14);

/**
  @brief 处理iOS 10、macOS10.14 UNUserNotification.framework的对应的方法

 @param center [UNUserNotificationCenter currentNotificationCenter]
 @param response 用户对通知消息的响应对象
 @param completionHandler 回调对象，必须调用
 */
- (void)xgPushUserNotificationCenter:(nonnull UNUserNotificationCenter *)center
      didReceiveNotificationResponse:(nullable UNNotificationResponse *)response
               withCompletionHandler:(nonnull void (^)(void))completionHandler __IOS_AVAILABLE(10.0)__OSX_AVAILABLE(10.14);

/**
 @brief 监控TPNS服务地启动情况(已废弃)

 @param isSuccess TPNS是否启动成功
 @param error TPNS启动错误的信息
 */
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(nullable NSError *)error __deprecated_msg("You should no longer call it");

/**
 @brief 监控TPNS服务的终止情况

 @param isSuccess TPNS是否终止
 @param error TPNS推动终止错误的信息
 */
- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(nullable NSError *)error;

/**
 @brief 监控TPNS服务上报推送消息的情况

 @param isSuccess 上报是否成功
 @param error 上报失败的信息
 */
- (void)xgPushDidReportNotification:(BOOL)isSuccess error:(nullable NSError *)error;

/**
 @brief 监控设置TPNS服务器下发角标的情况

 @param isSuccess isSuccess 上报是否成功
 @param error 设置失败的信息
 */
- (void)xgPushDidSetBadge:(BOOL)isSuccess error:(nullable NSError *)error;

/**
 @brief 设备token注册TPNS服务的回调

 @param deviceToken APNs 生成的Device Token
 @param error 错误信息
 */
- (void)xgPushDidRegisteredDeviceToken:(nullable NSString *)deviceToken error:(nullable NSError *)error;

/**
 @brief 注册推送服务回调

 @param deviceToken APNs 生成的Device Token
 @param xgToken TPNS 生成的 Token，推送消息时需要使用此值。TPNS 维护此值与APNs 的 Device Token的映射关系
 @param error 错误信息，若error为nil则注册推送服务成功
 */
- (void)xgPushDidRegisteredDeviceToken:(nullable NSString *)deviceToken xgToken:(nullable NSString *)xgToken error:(nullable NSError *)error;

/**
 @brief 设备token注册TPNS服务的回调

 @param deviceToken 当前设备的token
 @param error 错误信息
 @note 暂不支持
 */
- (void)xgPushDidRegisteredPushKitDeviceToken:(nullable NSString *)deviceToken error:(nullable NSError *)error;

/**
 @brief 当PushKit token失效时，用以通知delegate
 @note 暂不支持
 */
- (void)xgPushDidInvalidatePushKitToken;

@end

/**
  @brief 账号类型，用以细分账号类别
 */

typedef NS_ENUM(NSUInteger, XGPushTokenAccountType) {
    XGPushTokenAccountTypeUNKNOWN = (0),          // 未知类型，单账号绑定默认使用
    XGPushTokenAccountTypeCUSTOM = (1),           // 自定义
    XGPushTokenAccountTypeIDFA = (1001),          // 广告唯一标识 IDFA
    XGPushTokenAccountTypePHONE_NUMBER = (1002),  //手机号码
    XGPushTokenAccountTypeWX_OPEN_ID = (1003),    // 微信 OPENID
    XGPushTokenAccountTypeQQ_OPEN_ID = (1004),    // QQ OPENID
    XGPushTokenAccountTypeEMAIL = (1005),         // 邮箱
    XGPushTokenAccountTypeSINA_WEIBO = (1006),    // 新浪微博
    XGPushTokenAccountTypeALIPAY = (1007),        // 支付宝
    XGPushTokenAccountTypeTAOBAO = (1008),        // 淘宝
    XGPushTokenAccountTypeDOUBAN = (1009),        // 豆瓣
    XGPushTokenAccountTypeFACEBOOK = (1010),      // FACEBOOK
    XGPushTokenAccountTypeTWRITTER = (1011),      // TWRITTER
    XGPushTokenAccountTypeGOOGLE = (1012),        // GOOGLE
    XGPushTokenAccountTypeBAIDU = (1013),         // 百度
    XGPushTokenAccountTypeJINGDONG = (1014),      // 京东
    XGPushTokenAccountTypeLINKIN = (1015)         // LINKIN
};

/**
 @brief 管理TPNS服务的对象，负责注册推送权限、消息的管理、调试模式的开关设置等
 */
@interface XGPush : NSObject

#pragma mark - 初始化相关

/**
 @brief 获取TPNS管理的单例对象

 @return TPNS对象
 */
+ (nonnull instancetype)defaultManager;

/**
 @brief 关于TPNS SDK接口协议的对象
 */
@property (weak, nonatomic, nullable, readonly) id<XGPushDelegate> delegate;

/**
 @brief TPNS管理对象，管理推送的配置选项，例如，注册推送的样式
 */
@property (nullable, strong, nonatomic) XGNotificationConfigure *notificationConfigure;

/**
 @brief 这个开关表明是否打印TPNS SDK的日志信息
 */
@property (assign, getter=isEnableDebug) BOOL enableDebug;

/**
 @brief 返回TPNS服务的状态
 */
@property (assign, readonly) BOOL xgNotificationStatus __deprecated_msg("Instead, you should get the status by xgPushDidRegisteredDeviceToken:error:")
    ;

/**
  @brief 设备在TPNS服务中的是否处于注册状态
 */
@property (assign, readonly)
    BOOL deviceDidRegisteredXG __deprecated_msg("Instead, you should get the status by xgPushDidRegisteredDeviceToken:error:");

/**
 @brief 管理应用角标
 @note 需要在主线程调用
 */
@property (nonatomic) NSInteger xgApplicationBadgeNumber;

/**
 @brief 传递didFinishLaunchingWithOptions的launchOptions，用于推送拉起app"启动数"统计
 @note 在startXGWithAppID之前调用，使用[launchOptions mutableCopy]传值
 */
@property (nonatomic, strong) NSMutableDictionary * _Nullable launchOptions;

/**
 @brief 通过使用在TPNS官网注册的应用的信息，启动TPNS服务

 @param appID 通过TPNS管理台申请的 AccessID
 @param appKey 通过TPNS管理台申请的 AccessKey
 @param delegate 回调对象
 @note 接口所需参数必须要正确填写，反之TPNS服务将不能正确为应用推送消息
 */
- (void)startXGWithAppID:(uint32_t)appID appKey:(nonnull NSString *)appKey delegate:(nullable id<XGPushDelegate>)delegate;

/**
 @brief 停止TPNS服务
 @note
 调用此方法将导致当前设备不再接受TPNS服务推送的消息.如果再次需要接收TPNS服务的消息推送，则必须需要再次调用startXG:withAppKey:delegate:方法重启TPNS服务
 */
- (void)stopXGNotification;

/**
@brief 上报统计数据
@note 此接口只需要在mac OS 启动方法中调用
*/

#if TARGET_OS_IPHONE
- (void)reportXGNotificationInfo:(nonnull NSDictionary *)info __deprecated_msg("You should no longer call it, SDK handles it automatically.");
#elif TARGET_OS_MAC
- (void)reportXGNotificationInfo:(nonnull NSDictionary *)info;
#endif

/**
 @brief 上报推送消息的用户行为

 @param response 用户行为
 @note 此接口即统计推送消息中开发者预先设置或者是系统预置的行为标识，可以了解到用户是如何处理推送消息的，又统计消息的点击次数
 */
- (void)reportXGNotificationResponse:(nullable UNNotificationResponse *)response __IOS_AVAILABLE(10.0)__OSX_AVAILABLE(10.14)
                                         __deprecated_msg("You should no longer call it, SDK handles it automatically.");

/**
 @brief 上报地理位置信息

 @param latitude 纬度
 @param longitude 经度
 */
- (void)reportLocationWithLatitude:(double)latitude longitude:(double)longitude __deprecated;

/**
 @brief 上报当前App角标数到TPNS服务器

 @param badgeNumber 应用的角标数
 @note 此接口是为了实现角标+1的功能，服务器会在这个数值基础上进行角标数新增的操作，调用成功之后，会覆盖之前值
 */
- (void)setBadge:(NSInteger)badgeNumber;

/**
 @brief 查询设备通知权限是否被用户允许

 @param handler 查询结果的返回方法
 @note iOS 10 or later 回调是异步地执行
 */
- (void)deviceNotificationIsAllowed:(nonnull void (^)(BOOL isAllowed))handler;

/**
 @brief 查看SDK的版本

 @return sdk版本号
 */
- (nonnull NSString *)sdkVersion;

/**
 @brief 上报日志信息 (TPNS SDK1.2.4.1+)
 @param handler 异步地返回上报结果
 @note 回调参数可能会被触发多次，如果存在多个日志文件
*/
- (void)uploadLogCompletionHandler:(nullable void (^)(BOOL result, NSString *_Nullable errorMessage))handler;

@end
