<div align=center>
<img src="https://github.com/Maru-zhang/SwiftyEventBus/blob/master/Screenshots/SwiftyEventBus-Logo.png"/>
    
<div align=left>

# SwiftyEventBus

![](https://img.shields.io/badge/language-swift-orange.svg)
[![CI Status](https://img.shields.io/travis/Maru-zhang/SwiftyEventBus.svg?style=flat)](https://travis-ci.org/Maru-zhang/SwiftyEventBus)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov](https://codecov.io/gh/Maru-zhang/SwiftyEventBus/branch/master/graph/badge.svg)](https://codecov.io/gh/Maru-zhang/SwiftyEventBus)
[![Version](https://img.shields.io/cocoapods/v/SwiftyEventBus.svg?style=flat)](https://cocoapods.org/pods/SwiftyEventBus)
[![License](https://img.shields.io/cocoapods/l/SwiftyEventBus.svg?style=flat)](https://cocoapods.org/pods/SwiftyEventBus)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyEventBus.svg?style=flat)](https://cocoapods.org/pods/SwiftyEventBus)

SwiftyEventBus is a publish/subscribe event bus for iOS and Swift.

* simplifies the communication between components
* make your code simple and elegant
* type safe
* more advance feature: safety event, sticky event, etc...

In addition, if you want to read document, please click [here](https://maru-zhang.github.io/SwiftyEventBus/).

## Usage

`SwiftyEventBus` is very easy to use, you just need two steps:

#### 1.**Register**

You can register in anywhere with any type, it will always observe until the `EventSubscription` object been released.

```swift
class DemoViewController: UIViewController {

    var ob: EventSubscription<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ob = EventBus.`default`.register { (x: String) in
            print(x)
        }
    }
}
```

#### 2.**Post**

Finally, you just need to post any type that implement `EventPresentable`.


```swift
EventBus.default.post("Foo")
```

### Advance

#### Safe Post

Sometime, you maybe post a message that no one obseving, this is unsafety behaviour, then you can use this:

```swift
EventBus.default.safePost("Foo")
```

If there is no observer subscribe this kind of message, `EventBus.default.safePost("Foo")` will raise `EventBusPostError.useless` Exception, you can catch it and handle this.

```swift
/// handle EventBusPostError excetion
do {
    try EventBus.default.safePost("foo")
} catch {
    // do something
}
```

### Rx-Extension

if you project using `RxSwift`, maybe you need this to bridge `SwiftyEventBus` to `Rx`.

```ruby
pod 'SwiftyEventBus/Rx'
```

after that, you can use `SwiftyEventBus` in `RxSwift` world.🎉

```swift
var bag: DisposeBag? = DisposeBag()
EventBus.default.rx.register(String.self)
    .subscribe(onNext: { (x) in
        print(x) /// "foo"
    })
    .disposed(by: bag!)
EventBus.default.post("foo")
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

### CocoaPods

SwiftyEventBus is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyEventBus'
```

### 

SwiftyEventBus is also available on `Carthage`, please add this to `Cartfile`:

```
github "Maru-zhang/SwiftyEventBus"
```

## Author

Maru-zhang, maru-zhang@foxmail.com

## License

SwiftyEventBus is available under the MIT license. See the LICENSE file for more info.


