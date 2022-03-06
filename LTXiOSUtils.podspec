Pod::Spec.new do |s|
  s.name         = "LTXiOSUtils"
  s.version      = "0.0.3"
  s.platform     = :ios, "10.0" # iOS平台最低版本 10.0
  s.summary      = "通用工具类以及组件的整合、封装以及使用介绍"
  s.homepage     = "https://github.com/Coder-Star/LTXiOSUtils"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "CoderStar" => "1340529758@qq.com" }

  #  s.source       = { :git => "https://github.com/Coder-Star/LTXiOSUtils.git", :tag => s.version } # 发布时启用
  s.source       = { :git => 'local', :tag => s.version} # 本地开发，local是随便起的名字

  s.requires_arc = true
  s.swift_version = ["5","4.2"]
  #  s.static_framework  =  true

  # 模块化，假如组件中有OC代码，需要模块化，就需要进行开启，并且配合public_header_files使用，其中public_header_files加入的.h文件会反映到umbrella.h文件中去，如果自己创建framework，就需要自己创建umbrella.h文件，将自己想要保留的oc .h文件加入进去
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  
  # 架构第一层；包含Swift扩展、核心工具

  # 核心类，其他子组件依赖该子组件
  s.subspec 'Core' do |core|
    # 扩展
    core.subspec 'Extension' do |extension|
      extension.frameworks = "UIKit","Foundation"
      extension.source_files = 'Sources/LTXiOSUtils/Classes/Core/Extension/*.swift'
    end
    # 核心工具
    core.subspec 'CoreUtil' do |coreUtil|
      coreUtil.frameworks = "UIKit","Foundation"
      coreUtil.source_files = 'Sources/LTXiOSUtils/Classes/Core/CoreUtil/**/*.swift'
    end
  end


  # 架构第二层；包含UI组件、网络请求、工具类等

  # 网络请求
  s.subspec 'Network' do |network|
    network.dependency 'LTXiOSUtils/Core'
    network.dependency 'Alamofire','5.4.3'
    network.source_files = 'Sources/LTXiOSUtils/Classes/Network/*.swift'
  end

  # 工具类
  s.subspec 'Util' do |util|
    util.source_files = 'Sources/LTXiOSUtils/Classes/Util/**/*.swift'
  end

  # PropertyWrapper
  s.subspec 'PropertyWrapper' do |util|
    util.source_files = 'Sources/LTXiOSUtils/Classes/PropertyWrapper/**/*.swift'
  end

  # UI组件
  s.subspec 'Component' do |component|
    component.dependency 'LTXiOSUtils/Core'
    component.source_files = 'Sources/LTXiOSUtils/Classes/Component/**/*.swift'

    component.subspec 'Resources' do |resources|
      resources.resource_bundle = { "LTXiOSUtilsComponent" => "Sources/LTXiOSUtils/Classes/Component/Resources/Resource/*" } # LTXiOSUtil是bundle的名称
    end
  end
end


# fastlane release_pod project:"LTXiOSUtils" version:"s.version" desc:"tag desc"
# fastlane release_pod project:"LTXiOSUtils" version:"s.version"
# fastlane release_pod repo:"coder-star" project:"LTXiOSUtils" version:"s.version" desc:"tag desc"
