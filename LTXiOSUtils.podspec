Pod::Spec.new do |s|
  s.name         = "LTXiOSUtils"
  s.version      = "1.0.0"
  s.platform     = :ios, "10.0" #iOS平台最低版本 10.0
  s.summary      = "通用工具类以及组件的整合、封装以及使用介绍"
  s.homepage     = "https://github.com/Coder-Star/LTXiOSUtils"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "CoderStar" => "1340529758@qq.com" }

  s.source       = { :git => "https://github.com/Coder-Star/LTXiOSUtils.git", :tag => s.version } #发布
#  s.source       = { :git => 'local', :tag => s.version} #本地开发

  s.requires_arc = true
  s.swift_version = ["5","4.2"]

  s.dependency 'SwiftyJSON' # 处理JSON
  s.dependency 'SnapKit' # 自动布局
  s.dependency 'Alamofire' # 网络请求
  s.dependency 'Moya' # 网络抽象层
  s.dependency 'QorumLogs' # 日志工具
  
  s.dependency 'MBProgressHUD' # 加载框，OC库
  s.dependency 'MJRefresh'  # 下拉刷新、下拉加载，OC库

  #    s.resources     = 'Source/Resource/**/*' # 资源路径

  s.subspec 'Utils' do |ss1|
    ss1.source_files = 'LTXiOSUtils/Classes/Utils/*.swift'
  end

  s.subspec 'Views' do |ss2|
    ss2.dependency 'LTXiOSUtils/Utils'
    ss2.source_files = 'LTXiOSUtils/Classes/Views/*.swift'
  end

  s.subspec 'ViewControllers' do |ss3|
    ss3.dependency 'LTXiOSUtils/Utils'
    ss3.source_files = 'LTXiOSUtils/Classes/ViewControllers/*.swift'
  end

end
