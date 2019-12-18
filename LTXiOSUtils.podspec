Pod::Spec.new do |s|
  s.name         = "LTXiOSUtils"
  s.version      = "1.0.0.1"
  s.platform     = :ios, "10.0" #iOS平台最低版本 10.0
  s.summary      = "通用工具类以及组件的整合、封装以及使用介绍"
  s.homepage     = "https://github.com/Coder-Star/LTXiOSUtils"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "CoderStar" => "1340529758@qq.com" }

#  s.source       = { :git => "https://github.com/Coder-Star/LTXiOSUtils.git", :tag => s.version } #发布
  s.source       = { :git => 'local', :tag => s.version} #本地开发

  s.requires_arc = true
  s.swift_version = ["5","4.2"]

#  s.dependency 'QorumLogs','0.9' # 日志工具

#  s.dependency 'Alamofire','4.9.1' # 网络请求
#  s.dependency 'Moya','13.0.1' # 网络抽象层
#  s.dependency 'MJRefresh','3.3.1'  # 下拉刷新、下拉加载，OC库
  s.dependency 'MBProgressHUD','1.1.0' # 加载框，OC库

#  s.dependency 'SwiftyJSON','5.0.0' # 处理JSON

  #    s.resources     = 'Source/Resource/**/*' # 资源路径

  s.subspec 'Utils' do |utils|
    utils.source_files = 'LTXiOSUtils/Classes/Utils/*.swift'
  end

  s.subspec 'Views' do |views|
    views.dependency 'LTXiOSUtils/Utils'
    views.source_files = 'LTXiOSUtils/Classes/Views/*.swift'
  end

  s.subspec 'ViewControllers' do |viewControllers|
    viewControllers.dependency 'LTXiOSUtils/Utils'
    viewControllers.dependency 'SnapKit','5.0.1' # 自动布局
    viewControllers.source_files = 'LTXiOSUtils/Classes/ViewControllers/*.swift'
  end

end
