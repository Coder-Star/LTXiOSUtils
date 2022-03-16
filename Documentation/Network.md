Network里面定义的是一层网络抽象层，包含发送、接收、JSON转Model等操作，其中目前默认使用的是`Alamofire`发起网络请求，可对底层进行更换，而不影响上层API使用；

## 抽象方式

### APIRequest协议

负责构建一个`Request`请求，在构建中我们可以设置返回的`ResponseModel`;

### APIClient协议

负责发送一个`Request`请求，我们可以调整`APIClient`的实现方式；

目前默认实现方式为`Alamofire`;我们最终

### APIParsable协议

负责将网络请求回来的数据进行解析，转为实体；

## 默认使用方式

```swift
/// 返回的Model
struct HomeBanner: APIParsable, Codable {
    var interval: Int = 0
}

let request = DefaultNetRequest(responseType: HomeBanner.self, url: "你的API地止")

APIService.default.send(request: request) { result in
     switch result.result {
     case let .success(model):
          print(model)
     case let .failure(error):
          print(error)
     }
}
```

这是一个最简单的使用方式，我们可以直接在`.success`的回调中拿到我们反序列化后的`Model`。

但是这个方式肯定是满足不了我们业务中的场景的，那接下来我们看看怎么灵活扩展；



## 多主机

其实我们很有可能遇到App里面访问多个不同域名的服务器后台，那我们应该怎么处理呢？

我们可以自己实现`APIRequest`这个协议，如下：

```swift
public struct DomainOneNetRequest<T: APIParsable>: APIRequest {
    public var url: String

    public var method: NetRequestMethod

    public var parameters: [String: Any]?

    public var headers: NetRequestHeaders?

    public var httpBody: Data?

    public typealias Response = T

    /// 站点1 基础URL
    let domainOneBaseUrl = ""
}

extension DomainOneNetRequest {
    /// 最外层数据结构构建
    public init(responseType: Response.Type, url: String, method: NetRequestMethod = .get) {
        /// 拼接URL
        self.url = domainOneBaseUrl + url
        self.method = method
    }
}
```

这样每对应一个`domain`我们就定义这样一个`NetRequest`，我们在访问不同域名的API后台时，选择对应的`NetRequest`即可，并且我们可以把站点的域名收敛到构造函数里面，避免外面多次传入；

同时我们可以通过定义多个构造函数的方式给调用方提供是直接返回最外层数据结构的Model而是真正数据对应的Model。

```swift
extension DomainOneNetRequest {
    /// 数据层数据结构，最外层数据选用DefaultAPIResponseModel
    public init<S>(defaultDataType: S.Type, url: String, method: NetRequestMethod = .get) where DefaultAPIResponseModel<S> == T {
      	/// 拼接URL
        self.url = domainOneBaseUrl + url
        self.method = method
    }
}
```



## 更换最外层基础Model



我们只需要按照`DefaultAPIResponseModel`的形式定义自己的Model就可以了，相应使用者换掉就ok，上面场景就是一个例子；

```swift
public struct DomainOneAPIResponseModel<T>: APIParsable & Decodable where T: APIParsable & Decodable {
    public var code: Int
    public var msg: String
    public var data: T?    
}
```

## 解析协议发生变化

目前解析默认是由`JSON`通过`Decodable`的方式转为Model，但如果后台返回的数据不是`JSON`，而是`XML`或者`Protobuf`等，那我们可以对`APIParsable`协议进行扩展。

目前协议默认实现了当`Model`实现了`Decodable` 协议时候的自动转换；

那如果后续我们接入了`SwiftProtobuf`，我们可以使用下列方式进行扩展；

```swift
 extension APIParsable where Self: SwiftProtobuf.Message {
    public static func parse(data: Data) -> APIResult<Self> {
        do {
            let model = try self.init(serializedData: data)
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
 }
```

