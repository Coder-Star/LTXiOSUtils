####  注意点

* 测试方法需要以test开头，否则无法识别出来
* @testable import XXX 会将库引入进来，跟一般的import之间的区别可以体现在限制符上，比如使用import引入时，就需要将库里面方法加上public才可以调用到，但是使用@testable import 引用的话使用internal这个默认限制符就OK了
