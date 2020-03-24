Pod::Spec.new do |s|
  s.name         = "LTXiOSUtils"
  s.version      = "0.0.1"
  s.platform     = :ios, "10.0" # iOS平台最低版本 10.0
  s.summary      = "通用工具类以及组件的整合、封装以及使用介绍"
  s.homepage     = "https://github.com/Coder-Star/LTXiOSUtils"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "CoderStar" => "1340529758@qq.com" }

#  s.source       = { :git => "https://github.com/Coder-Star/LTXiOSUtils.git", :tag => s.version } # 发布
  s.source       = { :git => 'local', :tag => s.version} # 本地开发，local是随便起的名字

  s.requires_arc = true
  s.swift_version = ["5","4.2"]

  # 核心类，其他子组件依赖该子组件
  s.subspec 'Core' do |core|
    # 扩展
    core.subspec 'Extension' do |extension|
      extension.frameworks = "UIKit","Foundation"
      extension.source_files = 'LTXiOSUtils/Classes/Core/Extension/*.swift'
    end
    # 核心工具
    core.subspec 'CoreUtil' do |coreUtil|
      coreUtil.frameworks = "UIKit","Foundation"
      coreUtil.dependency 'MBProgressHUD','1.1.0' # 加载框，OC库
      coreUtil.source_files = 'LTXiOSUtils/Classes/Core/CoreUtil/**/*.swift'
    end
  end

  # 网络请求
  s.subspec 'Network' do |network|
    network.dependency 'LTXiOSUtils/Core'
    network.dependency 'ReachabilitySwift','5.0.0'  # 网络监听
    network.dependency 'Moya','14.0.0' # 网络抽象层，其依赖了Alamofire和Result
    network.source_files = 'LTXiOSUtils/Classes/Network/*.swift'
  end

  # 工具类
  s.subspec 'Util' do |util|
    util.source_files = 'LTXiOSUtils/Classes/Util/**/*.swift'
  end

  # 资源
  s.subspec 'Resources' do |resources|
    resources.dependency 'Localize-Swift','3.1.0' # 管理本地国际化文件
    resources.source_files = 'LTXiOSUtils/Resources/*.swift'
    resources.resource_bundle = { "LTXiOSUtils" => "LTXiOSUtils/Resources/Resource/*" } # LTXiOSUtil是bundle的名称
  end

  # 自定义Component组件，包含各种基础view
  s.subspec 'Component' do |component|
    component.dependency 'LTXiOSUtils/Resources'
    component.dependency 'LTXiOSUtils/Core'
    component.dependency 'SnapKit','5.0.1' # 自动布局
    component.source_files = 'LTXiOSUtils/Classes/Component/**/*.swift'
  end

  # 基础ViewController
  s.subspec 'ViewController' do |viewController|
    viewController.dependency 'LTXiOSUtils/Core/Extension'
    viewController.dependency 'SnapKit' # 自动布局
    viewController.dependency 'MJRefresh' # 下拉刷新、下拉加载，OC库
    viewController.source_files = 'LTXiOSUtils/Classes/ViewController/**/*.swift'
  end

end


# fastlane release_pod project:"LTXiOSUtils" version:"s.version" desc:"tag desc"
# fastlane release_pod project:"LTXiOSUtils" version:"s.version"
# fastlane release_pod repo:"coder-star" project:"LTXiOSUtils" version:"s.version" desc:"tag desc"
