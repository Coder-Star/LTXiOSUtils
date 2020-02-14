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

  #  s.dependency 'MJRefresh','3.3.1'  # 下拉刷新、下拉加载，OC库

  # 核心类，其他子组件依赖该子组件
  s.subspec 'Core' do |core|
    # 核心作用域
    core.subspec 'Scope' do |scope|
      scope.frameworks = "Foundation"
      scope.source_files = 'LTXiOSUtils/Classes/Core/Scope/*.swift'
    end
    # 扩展
    core.subspec 'Extension' do |extension|
      extension.frameworks = "UIKit","Foundation"
      extension.dependency 'LTXiOSUtils/Core/Scope'
      extension.source_files = 'LTXiOSUtils/Classes/Core/Extension/*.swift'
    end
    # 工具
    core.subspec 'Util' do |util|
      util.frameworks = "UIKit","Foundation"
      util.dependency 'LTXiOSUtils/Core/Extension'
      util.source_files = 'LTXiOSUtils/Classes/Core/Util/**/*.swift'
    end
  end

  # 网络请求
  s.subspec 'Network' do |network|
    network.dependency 'LTXiOSUtils/Core/Extension'
    network.dependency 'LTXiOSUtils/Component'
    network.dependency 'Alamofire'  # 网络请求
    network.dependency 'Moya' # 网络抽象层
    network.dependency 'SwiftyJSON' # 处理JSON
    network.source_files = 'LTXiOSUtils/Classes/Network/*.swift'
  end

  # 资源
  s.subspec 'Resource' do |resource|
    resource.dependency 'Localize-Swift' # 管理本地国际化文件
    resource.source_files = 'LTXiOSUtils/Resources/*.swift'
    resource.resource_bundle = { "LTXiOSUtils" => "LTXiOSUtils/Resources/Resource/*" } # LTXiOSUtil是bundle的名称
  end

  # 自定义Component组件，包含各种基础view
  s.subspec 'Component' do |component|
    component.dependency 'LTXiOSUtils/Resource'
    component.dependency 'LTXiOSUtils/Core/Extension'
    component.dependency 'SnapKit' # 自动布局
    component.dependency 'MBProgressHUD' # 加载框，OC库
    component.source_files = 'LTXiOSUtils/Classes/Component/**/*.swift'
  end

  # 基础ViewController
  s.subspec 'ViewController' do |viewController|
    viewController.dependency 'LTXiOSUtils/Core/Extension'
    viewController.dependency 'SnapKit' # 自动布局
    viewController.source_files = 'LTXiOSUtils/Classes/ViewController/*.swift'
  end

end


# fastlane release_pod project:"LTXiOSUtils" version:"s.version" desc:"tag desc"
# fastlane release_pod project:"LTXiOSUtils" version:"s.version"
# fastlane release_pod repo:"coder-star" project:"LTXiOSUtils" version:"s.version" desc:"tag desc"
