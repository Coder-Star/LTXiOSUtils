Pod::Spec.new do |s|
  s.name         = "LTXiOSUtils"
  s.version      = "1.0.0.1"
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

  # 工具相关，算是核心类，其他很多子组件依赖该组件
  s.subspec 'Tools' do |tools|

    # 扩展
    tools.subspec 'Extensions' do |extensions|
      extensions.source_files = 'LTXiOSUtils/Classes/Tools/Extensions/*.swift'
    end

    # 工具
    tools.subspec 'Utils' do |utils|
      utils.dependency 'LTXiOSUtils/Tools/Extensions'
      utils.dependency 'MBProgressHUD','1.1.0' # 加载框，OC库
      utils.source_files = 'LTXiOSUtils/Classes/Tools/Utils/*.swift'
    end

    # 网络请求
    tools.subspec 'Network' do |network|
      network.dependency 'LTXiOSUtils/Tools/Utils'
      network.dependency 'LTXiOSUtils/Tools/Extensions'
      network.dependency 'Alamofire','4.9.1'  # 网络请求
      network.dependency 'Moya','13.0.1' # 网络抽象层
      network.dependency 'SwiftyJSON','5.0.0' # 处理JSON
      network.source_files = 'LTXiOSUtils/Classes/Tools/Network/*.swift'
    end

  end

  # 静态常量
  s.subspec 'Constants' do |constants|
    constants.source_files = 'LTXiOSUtils/Classes/Constants/*.swift'
  end

  # 资源
  s.subspec 'Resources' do |resources|
    resources.dependency 'Localize-Swift','3.1.0' # 管理本地国际化文件
    resources.source_files = 'LTXiOSUtils/Resources/*.swift'
    resources.resource_bundle = { "LTXiOSUtils" => "LTXiOSUtils/Resources/Resource/*" } # LTXiOSUtil是bundle的名称
  end

  # 自定义View
  s.subspec 'Views' do |views|
    views.dependency 'LTXiOSUtils/Resources'
    views.dependency 'LTXiOSUtils/Constants'
    views.dependency 'LTXiOSUtils/Tools/Extensions'
    views.source_files = 'LTXiOSUtils/Classes/Views/**/*.swift'
  end

  # 基础ViewController
  s.subspec 'ViewControllers' do |viewControllers|
    viewControllers.dependency 'LTXiOSUtils/Constants'
    viewControllers.dependency 'SnapKit','5.0.1' # 自动布局
    viewControllers.source_files = 'LTXiOSUtils/Classes/ViewControllers/*.swift'
  end

end
