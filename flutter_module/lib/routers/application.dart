/// APP环境参数
enum Env {
  /// 开发环境
  dev,

  /// 生产环境
  prod,
}

/// 应用配置
class Application {
  ///
  static final Env env = Env.dev;
}
