# BRPickerView

BRPickerView 封装的是iOS中常用的选择器组件，主要包括：日期选择器、时间选择器、地址选择器、自定义字符串选择器。高度封装，提供了两种使用方式，支持自定义主题样式，适配深色模式。

【**特别提示**】：

- 当前最新版本为： `2.4.5` 。
- 如果不能找到最新版本，请先执行一下 `pod repo update` 更新本地仓库，待更新完成后；再执行 `pod search BRPickerView` 进行搜索，就会看到最新版本。

# 效果演示

查看并运行 `BRPickerViewDemo.xcodeproj`

| ![效果图1](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/a.gif?raw=true) | ![效果图2](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/b.gif?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                     框架Demo运行效果图1                      |                     框架Demo运行效果图2                      |

# 安装

#### 1. CocoaPods

1. 在 Podfile 中添加 `pod 'BRPickerView'`。

2. 执行 `pod install` 或 `pod update` 。

3. 导入头文件 ` #import <BRPickerView.h>`。


#### 2. 手动导入

1. 将与 `README.md` 同级目录下的 `BRPickerView` 文件夹拽入项目中

2. 导入头文件 ` #import "BRPickerView.h"`。


# 系统要求

- iOS 8.0+
- ARC

# 使用

#### 1. 时间选择器：`BRDatePickerView`

​	查看 BRDatePickerView.h 头文件，里面提供了两种使用方式，参见源码。

```objective-c
/// 日期选择器类型
typedef NS_ENUM(NSInteger, BRDatePickerMode) {
    // ----- 以下4种是系统自带的样式 -----
    /** 【HH:mm】UIDatePickerModeTime */
    BRDatePickerModeTime = 1,
    /** 【yyyy-MM-dd】UIDatePickerModeDate */
    BRDatePickerModeDate,
    /** 【yyyy-MM-dd HH:mm】 UIDatePickerModeDateAndTime */
    BRDatePickerModeDateAndTime,
    /** 【HH:mm】UIDatePickerModeCountDownTimer */
    BRDatePickerModeCountDownTimer,
    
    // ----- 以下11种是自定义样式 -----
    /** 【yyyy-MM-dd HH:mm:ss】年月日时分秒 */
    BRDatePickerModeYMDHMS,
    /** 【yyyy-MM-dd HH:mm】年月日时分 */
    BRDatePickerModeYMDHM,
    /** 【yyyy-MM-dd HH】年月日时 */
    BRDatePickerModeYMDH,
    /** 【MM-dd HH:mm】月日时分 */
    BRDatePickerModeMDHM,
    /** 【yyyy-MM-ddEEE】年月日星期 */
    BRDatePickerModeYMDE,
    /** 【yyyy-MM-dd】年月日 */
    BRDatePickerModeYMD,
    /** 【yyyy-MM】年月 */
    BRDatePickerModeYM,
    /** 【yyyy】年 */
    BRDatePickerModeY,
    /** 【MM-dd】月日 */
    BRDatePickerModeMD,
    /** 【HH:mm:ss】时分秒 */
    BRDatePickerModeHMS,
    /** 【HH:mm】时分 */
    BRDatePickerModeHM
};
```

- 使用示例（参考Demo）：

```objective-c
// 1.创建日期选择器
BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeYMD];
// 2.设置属性
datePickerView.title = @"选择年月日";
// datePickerView.selectValue = @"2019-10-30";
datePickerView.selectDate = [NSDate br_setYear:2019 month:10 day:30];
datePickerView.minDate = [NSDate br_setYear:1949 month:3 day:12];
datePickerView.maxDate = [NSDate date];
datePickerView.isAutoSelect = YES;
// datePickerView.addToNow = YES;  // 是否添加“至今”
// datePickerView.showToday = YES; // 是否显示“今天”
datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
    NSLog(@"选择的值：%@", selectValue);
};
// 自定义主题样式
BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
customStyle.pickerColor = BR_RGB_HEX(0xd9dbdf, 1.0f);
customStyle.pickerTextColor = [UIColor redColor];
customStyle.separatorColor = [UIColor redColor];
datePickerView.pickerStyle = customStyle;

// 3.显示
[datePickerView show];
```

- 时间选择器显示类型的效果图：

> 以下4种样式是使用 UIDatePicker 类 进行封装的，支持循环滚动

| ![样式1：BRDatePickerModeTime](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type1.png?raw=true) | ![样式2：BRDatePickerModeDate](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type2.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                 样式1：BRDatePickerModeTime                  |                 样式2：BRDatePickerModeDate                  |
|                                                              |                                                              |
| ![样式3：BRDatePickerModeDateAndTime](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type3.png?raw=true) | ![样式4：BRDatePickerModeCountDownTimer](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type4.png?raw=true) |
|              样式3：BRDatePickerModeDateAndTime              |            样式4：BRDatePickerModeCountDownTimer             |

> 以下11种样式是使用 UIPickerView 类 进行封装的。

| ![样式5：BRDatePickerModeYMDHMS](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type5.png?raw=true) | ![样式6：BRDatePickerModeYMDHM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type6.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                样式5：BRDatePickerModeYMDHMS                 |                 样式6：BRDatePickerModeYMDHM                 |
|                                                              |                                                              |
| ![样式7：BRDatePickerModeYMDH](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type7.png?raw=true) | ![样式8：BRDatePickerModeMDHM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type8.png?raw=true) |
|                 样式7：BRDatePickerModeYMDH                  |                 样式8：BRDatePickerModeMDHM                  |
|                                                              |                                                              |
| ![样式9：BRDatePickerModeYMDE](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type9.png?raw=true) | ![样式10：BRDatePickerModeYMD](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type10.png?raw=true) |
|                 样式9：BRDatePickerModeYMDE                  |                 样式10：BRDatePickerModeYMD                  |
|                                                              |                                                              |
| ![样式11：BRDatePickerModeYM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type11.png?raw=true) | ![样式12：BRDatePickerModeY](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type12.png?raw=true) |
|                  样式11：BRDatePickerModeYM                  |                  样式12：BRDatePickerModeY                   |
|                                                              |                                                              |
| ![样式13：BRDatePickerModeMD](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type13.png?raw=true) | ![样式14：BRDatePickerModeHMS](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type14.png?raw=true) |
|                  样式13：BRDatePickerModeMD                  |                 样式14：BRDatePickerModeHMS                  |
|                                                              |                                                              |
| ![样式15：BRDatePickerModeHM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type15.png?raw=true) |                                                              |
|                  样式15：BRDatePickerModeHM                  |                                                              |

#### 2. 地址选择器：`BRAddressPickerView`

​	查看 BRAddressPickerView.h 头文件，里面提供了两种使用方式，参见源码。

- 使用示例（参考Demo）：

```objective-c
/// 地址选择器
BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]initWithPickerMode:BRAddressPickerModeArea];

addressPickerView.title = @"请选择地区";
//addressPickerView.defaultSelectedArr = @[@"浙江省", @"杭州市", @"西湖区"];
addressPickerView.selectIndexs = @[@10, @0, @4];
addressPickerView.isAutoSelect = YES;
addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
    NSLog(@"选择的值：%@", [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name]);
};
// 自定义主题样式（适配深色模式）
addressPickerView.pickerStyle = [self pickerStyleWithDarkModel];

[addressPickerView show];
```

- 地址选择器的3种显示类型（showType 的3个枚举值）：

| ![省份](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/BRAddressPickerModeProvince.png?raw=true) | ![城市](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/BRAddressPickerModeCity.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|              样式1：BRAddressPickerModeProvince              |                样式2：BRAddressPickerModeCity                |
| ![地区](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/BRAddressPickerModeArea.png?raw=true) |                                                              |
|                样式3：BRAddressPickerModeArea                |                                                              |

#### 3.  自定义字符串选择器：`BRStringPickerView`

​	查看 BRStringPickerView.h 头文件，里面提供了两种使用方式，参见源码。

- 使用示例（参考Demo）：

```objective-c
/// 单列字符串选择器
BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];

stringPickerView.title = @"请选择性别";
stringPickerView.dataSourceArr = @[@"男", @"女", @"其他"];
stringPickerView.selectIndex = 1;
stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
    NSLog(@"选择的值：%@", resultModel.name);
};

[stringPickerView show];


/// 多列字符串选择器
BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentMulti];

stringPickerView.title = @"自定义多列字符串";
stringPickerView.dataSourceArr = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
stringPickerView.selectIndexs = @[@2, @3];
stringPickerView.isAutoSelect = YES;
stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> *resultModelArr) {
    NSLog(@"选择的值：%@", [NSString stringWithFormat:@"%@，%@", resultModelArr[0].name, resultModelArr[1].name]);
};
// 自定义主题样式
addressPickerView.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor orangeColor]];

[stringPickerView show];
```

- 字符串选择器效果图：

| ![自定义单列字符串](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/string_single.png?raw=true) | ![自定义多列字符串](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/string_more.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|              单列字符串选择器（默认主题色样式）              |             双列字符串选择器（自定义主题色样式）             |

| ![3列效果图](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/string_more3.png?raw=true) | ![4列效果图](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/string_more4.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|             3列字符串选择器（自定义主题色样式）              |             4列字符串选择器（自定义主题色样式）              |

# 更新记录

#### 2019-11-28（V2.4.5）

- 日期选择器新增选择 ”至今“ 和 显示 ”今天“ 的功能，见以下两个属性：

  `showToday` ：控制是否显示 “今天” ，默认为 NO

  `addToNow`：控制是否添加选择 “至今”，默认为 NO

#### 2019-11-26（V2.4.3）

- 日期选择器新增以下三种选择类型：

  `BRDatePickerModeYMDHMS`（年月日时分秒）、`BRDatePickerModeYMDE`（年月日星期）、`BRDatePickerModeHMS`（时分秒）

- 更新地址选择器地区数据源

#### 2019-11-07（V2.4.2）

- 日期选择器添加：BRDatePickerModeYMDH（yyyy-MM-dd HH）类型
- 地址选择器添加：selectIndexs 属性，可根据索引去设置默认选择
- 适配横屏及刘海屏安全区域显示效果

#### 2019-11-04（V2.4.0）

- 优化选择器子目录管理，方便轻量级、模块化集成

  `pod 'BRPickerView'`	// 集成全部的功能

  `pod 'BRPickerView/DatePickerView'`	// 仅集成日期选择器的功能

  `pod 'BRPickerView/AddressPickerView'`	// 仅集成地址选择器的功能

  `pod 'BRPickerView/StringPickerView'`	// 仅集成字符串选择器的功能

#### 2019-11-01（V2.3.8）

- 优化代码，添加更多的自定义样式属性

#### 2019-10-30（V2.3.6）

- 优化代码，添加国际化支持

#### 2019-10-26（V2.3.5）

- 添加传统的创建对象设置属性的使用方式
- 开放设置选择器颜色及样式，适配深色模式
- 更新省市区数据源，数据与政府官网最新公布的一致（参见：[行政区划代码](http://www.mca.gov.cn/article/sj/xzqh/2019/)）
- 支持将选择器添加到指定容器视图上（见BaseView.h文件，扩展一方法）
- 支持将子视图添加到选择器上（见BaseView.h文件，扩展二方法）
- 优化代码，配置Pod库的层级目录

#### 2018-04-27（V2.2.1）:

- 修复bug，适配iPad和横屏显示。
- 优化代码，提高框架适应性，降低内存消耗。

#### 2018-04-03（V2.2.0）

- 时间选择器新添加了7种显示类型（BRDatePickerMode），可根据自己项目的需求选择性使用。
- 适配横屏，及 iPhoneX 底部安全区域。
- 修改了最小时间和最大时间的参数名称（以前版本是传 NSString 类型， 现在传 NSDate 类型）
- 修复比较时间大小时出现的bug。

#### 2018-03-19（V2.1.3）

- 修改地址选择器确认选择后的回调参数。
- 现修改如下：可通过省市区的模型获取省市区的 name（名称）、code（id）、index（索引）`resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {}`
- 去掉第三方依赖库 `MJExtension` ，修改为手动解析地址数据源。

#### 2018-03-11（V2.1.2）

- 重命名了Github用户名，更新项目相关的路径。（提示：pod之前的版本不受影响）

#### 2018-02-28（V2.1.1）

- 修复某些情况下无法用bundle加载本地数据源（BRCity.plist）bug。

#### 2018-01-26（V2.1.0）

- 给地址选择器添加了一个方法（见方法4），提供数据源参数，支持外部传入地区数据源。
- 提示：要注意数据源格式，参考 BRCity.json。可以把 BRCity.json 文件的内容放到后台去维护，通过后台接口获取地区数据源（即 BRCity.json 文件的内容）。

#### 2018-01-25（V2.0.0）

- 更新了地址数据源（BRCity.plist），地区信息是2018年最新最全的，与微信的地区信息完全一致。
- 支持自定义默认选择地址（格式：@[@"浙江省", @"杭州市", @"西湖区"]），支持下次点击进入地址选择器时，默认地址为上次选择的结果。
- 修改了日期选择器、地址选择器、字符串选择器的接口方法（删除了之前的方法2）。
- 添加了地址选择器显示类型，支持3种显示：只显示省份、显示省份和城市、显示省市区。

#### 2018-01-05（V1.3.0）

- 添加取消选择的回调方法（点击背景或取消按钮会执行 `cancelBlock` ）
- 合并了字符串选择器 数组数据源和plist数据源对应的方法，`dataSource` 参数支持两种类型：

#### 2018-01-02（V1.2.0）

- 添加支持自定义主题颜色的方法。

#### 2017-11-26（V1.1.0）

- 更换第三方依赖库。
- 用MJExtension 替换了 原来的YYModel，以前没有注意导入YYModel，同时又导入YYKit会导致重复导入而冲突（另外使用YYModel时，手动导入和pod导入 其中的头文件和方法名也不一样，所以很容易出错）。

#### 2017-11-16（V1.0.0）

- 初始版本！

# 许可证

BRPickerView 使用 MIT 许可证，详情见 LICENSE 文件。