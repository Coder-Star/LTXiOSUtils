#import "FlutterStarPlugin.h"
#if __has_include(<flutter_star_plugin/flutter_star_plugin-Swift.h>)
#import <flutter_star_plugin/flutter_star_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_star_plugin-Swift.h"
#endif

@implementation FlutterStarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterStarPlugin registerWithRegistrar:registrar];
}
@end
