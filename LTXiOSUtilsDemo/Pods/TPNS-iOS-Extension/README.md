在线集成文档地址：https://cloud.tencent.com/document/product/548/36663。

TPNS iOS SDK ReleaseNote

VERSION 1.2.8.0
-------------------------------------------
1. Added  "user attributes"  for personalized push
2. Added  "in-app messaging"  , we provide several templates
3. Fixed known issues

版本 1.2.8.0
-------------------------------------------
1. 新增「用户属性」相关接口，用于个性化推送
2. 新增「应用内消息」功能，以及若干应用内消息模板
3. 修复已知问题


VERSION 1.2.7.2
-------------------------------------------
1. Added custom event reporting
2. Increased the success rate of reporting  "arrivals"
3. Fixed known issues

版本 1.2.7.2
-------------------------------------------
1. 增加自定义事件上报功能
2. 增加"抵达数"上报的成功率
3. 修复已知问题

VERSION 1.2.7.1
-------------------------------------------
1. Reduced SDK startup time
2. Added new callback interface in case of registration failure
3. Optimized account and label interface
4. Fixed known issues

版本 1.2.7.1
-------------------------------------------
1. 减少 SDK 启动耗时
2. 新增注册失败的回调接口
3. 优化账号、标签接口
4. 修复已知问题
VERSION 1.2.6.1
-------------------------------------------
1. Improve stability, fix known issues caused by SDK

版本 1.2.6.1
-------------------------------------------
1. 提升稳定性，修复已知问题

VERSION 1.2.6.0
-------------------------------------------
1. Optimize access by adding a new registration callback
2. Added TPNS channel to send messages
3. Optimize data statistics
4. Fixed known issues

版本 1.2.6.0
-------------------------------------------
1. 优化接入，新增注册回调方法
2. 新增自建通道，支持TPNS通道下发消息
3. 优化数据统计
4. 修复已知问题

VERSION 1.2.5.4
-------------------------------------------
* Improve stability, fix known issues caused by SDK
	
版本 1.2.5.4
-------------------------------------------
* 提升稳定性，修复已知问题

VERSION 1.2.5.3
-------------------------------------------
* Support unregistration tokens for free clusters to prevent repeated pushes
* Support replacing duplicate messages in notification extensions

版本 1.2.5.3
-------------------------------------------
* 支持对信鸽免费集群进行反注册token，防止重复推送
* 新增支持在通知扩展中对重复的消息进行替换


VERSION 1.2.5.2
-------------------------------------------
* Improve accurate push, add enumeration of account types
* Improve stability, optimize log IO exception and iOS10 receive message callback exception

版本 1.2.5.2
-------------------------------------------
* 提升精准推送，新增账号类型的枚举
* 提升稳定性，优化日志IO异常和iOS10接收消息回调异常的问题


VERSION 1.2.5.1
-------------------------------------------
* Simplified SDK access, delete reporting API, SDK handles it automatically
* Improve stability, fix crash caused by SDK Cache

版本 1.2.5.1
-------------------------------------------
* 简化接入，删除上报接口，SDK自动处理
* 提升稳定性，修复缓存模块引发的Crash问题


VERSION 1.2.4.9
-------------------------------------------
* Improve stability, fix crash caused by message statistics and a memory leak
* Optimize SDK compatibility

版本 1.2.4.9
-------------------------------------------
* 提升稳定性，修复消息统计触发的崩溃问题和一处内存泄露问题
* 优化提升SDK兼容性

VERSION 1.2.4.8
-------------------------------------------
* Improve stability, fix crash caused by message statistics
版本 1.2.4.8
-------------------------------------------
* 提升稳定性，修复消息统计触发的崩溃问题

VERSION 1.2.4.7
-------------------------------------------
* Improve stability, fix crash caused by message statistics and log statistics
版本 1.2.4.7
-------------------------------------------
* 提升稳定性，修复消息统计和日志记录触发的崩溃问题


VERSION 1.2.4.6
-------------------------------------------
* Optimize SDK registration process and improve registration success rate
* Optimize rich media push, support resources without suffix
* Fix other known issues

版本 1.2.4.6
-------------------------------------------
* 优化SDK注册流程，提升注册成功率
* 优化富媒体推送，支持无后缀名的资源
* 修复其他已知问题


VERSION 1.2.4.5
-------------------------------------------
* Add SDK crash monitor
* Optimize message arrival statistics
* Optimize device count statistics
* Optimize SDK I/O performance
* Optimize and improve SDK stability


版本 1.2.4.5
-------------------------------------------
* SDK增加Crash监控
* 优化抵达数据统计
* 优化累计设备量统计
* 优化SDK I/O性能
* 优化提升SDK稳定性



VERSION 1.2.4.4
-------------------------------------------
* Optimize the SDK registration process and improve the reach of notification messages

版本 1.2.4.4
-------------------------------------------
* 优化SDK注册流程，提升通知消息触达


VERSION 1.2.4.3
-------------------------------------------
* Optimize SDK compatibility

版本 1.2.4.3
-------------------------------------------
* 优化提升SDK兼容性

VERSION 1.2.4.2
-------------------------------------------
* fix a bug about obtaining the TPNS Token

版本 1.2.4.2
-------------------------------------------
* 修复SDK获取TPNS Token的Bug

VERSION 1.2.4.1
-------------------------------------------
* Add a log upload API
* Optimize and improve SDK stability
* Optimize SDK compatibility

版本 1.2.4.1
-------------------------------------------
* 新增日志上传接口
* 优化提升SDK稳定性
* 优化提升SDK兼容性

VERSION 1.2.4.0
-------------------------------------------
* Fix the problem of single account binding callback
* Improve SDK compatibility with third parties Notification Plugin
* Newly differentiated device push environment to optimize statistics
* Optimize the cache logic for replacing App information
* Improve SDK registration success rate


版本 1.2.4.0
-------------------------------------------
* 修复单账号绑定回调的问题
* 提升SDK与第三方的兼容性
* 新增区分设备推送环境，从而优化统计数据
* 优化更换App信息的缓存逻辑
* 提升SDK注册成功率

VERSION 1.2.3.0
-------------------------------------------
* Fix a bug about DeviceToken changed

版本 1.2.3.0
-------------------------------------------
* 修复一个当设备Token变化时出现的bug


VERSION 1.2.2.1
-------------------------------------------
* Fix a bug about network connecting when other apis are called before SDK starting

版本 1.2.2.1
-------------------------------------------
* 修复一个当SDK未启动完成就调用其他接口而产生的网络连接的Bug


VERSION 1.2.2.0
-------------------------------------------
* Fix a bug about registering device to the TPNS server on iOS13
* Fix a bug about network connecting when the App status changed

版本 1.2.2.0
-------------------------------------------
* 修复iOS13上无法注册的问题
* 修复App状态切换时的网络连接的问题


VERSION 1.2.1.2
-------------------------------------------
* Fix a bug about clicking message statistics

版本 1.2.1.2
-------------------------------------------
* 修复点击数据统计bug


VERSION 1.2.1.1
-------------------------------------------
* 修复标签绑定接口在网络连接状态变化时存在的bug

VERSION 1.2.1.0
-------------------------------------------
* 新增查询信鸽服务生成的Token接口
* 修复单账号绑定失败的问题

VERSION 1.2.0.0
-------------------------------------------
* 新增独立上报数据SDK
* 优化终端注册服务
* 更新DeviceToken解析逻辑

VERSION 1.1.0.1
-------------------------------------------
* 修复用户名和密码认证逻辑
* 修复动态加载SDK的缺陷

VERSION 1.1.0.0
-------------------------------------------
* 增加PushKit插件
* 优化SDK启动耗时


VERSION 1.0.1.0
-------------------------------------------
* 增加长连接的推送


 VERSION 1.0.1.0
-------------------------------------------
* 增加对PushKit的插件化支持，目前功能仅限注册，注销，上报


 VERSION 1.0.0.0
-------------------------------------------
* 初始版本
