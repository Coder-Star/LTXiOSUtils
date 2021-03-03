##  Swift调用其余语言

Swift调用OC及C方法类似，就是将C或OC的.h文件放入桥接文件中，当第一次创建C/OC文件会弹出提示框询问是否自动创建一个桥接文件。
放入桥接文件后，Swift中就可以直接调用OC或者C的类了。

## OC调用Swift


 当class是NSObject的子类时，这个类便可以在 "Product Name-Swift.h"中 找到，默认携带 init 构造方法,这个Product Name是在Build Settings 可以看到，也就是说类必须继承NSObject。
 当类中的非private以及非fileprivate 方法以及变量被 @objc 修饰时，该变量或者方法便可以在 "Product Name-Swift.h"中 找到
 当在类上添加 @objcMembers 修饰时，该类中所有的 非private以及非fileprivate 方法以及变量 都可以在 "Product Name-Swift.h"中 找到
 如果需要OC与Swift中类、方法以及属性的名字不一致，可以在@objc(OCName)这种形式为OC单独定义名称，比如当swift中的类为中文时


 在swift 4之前，如果类继承了NSObject，编译器就会默认给这个类中的所有函数都标记为@objc，支持OC调用。
 苹果在Swift4中，修改了自动添加@objc的逻辑：一个继承NSObject的Swift类不在默认给所有函数添加@objc。只在实现OC接口和重写OC方法时，才自动给函数添加@objc标识。
 
