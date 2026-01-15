Pod::Spec.new do |s|
  s.name         = "LTXiOSUtils"
  s.version      = "0.0.4"
  s.platform     = :ios, "10.0" # iOS平台最低版本 10.0
  s.summary      = "通用工具类以及组件的整合、封装以及使用介绍"
  s.homepage     = "https://github.com/Coder-Star/LTXiOSUtils"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "CoderStar" => "1340529758@qq.com" }

  s.source       = { :git => "https://github.com/Coder-Star/LTXiOSUtils.git", :tag => s.version } # 发布时启用
#  s.source       = { :git => 'local', :tag => s.version} # 本地开发，local是随便起的名字

  s.requires_arc = true
  s.swift_version = '5.0'
  #  s.static_framework  =  true

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }

  s.subspec 'Extension' do |extension|
    extension.source_files = 'Sources/LTXiOSUtils/Classes/Extension/**/*.swift'
  end

  # 工具类
  s.subspec 'Util' do |util|
    util.source_files = 'Sources/LTXiOSUtils/Classes/Util/**/*'
    util.subspec 'Log' do |log|
      log.source_files = 'Sources/LTXiOSUtils/Classes/Util/Log/*.swift'
    end
  end

  # PropertyWrapper
  s.subspec 'PropertyWrapper' do |util|
    util.source_files = 'Sources/LTXiOSUtils/Classes/PropertyWrapper/**/*.swift'
  end

  # UI组件
  s.subspec 'Component' do |component|
    component.dependency "LTXiOSUtils/Extension"
    component.source_files = 'Sources/LTXiOSUtils/Classes/Component/**/*.swift'

    component.subspec 'Resources' do |resources|
      # LTXiOSUtilsComponent是bundle的名称
      resources.resource_bundle = { "LTXiOSUtilsComponent" => "Sources/LTXiOSUtils/Classes/Component/Resources/Resource/*" }
    end
  end
end


# fastlane release_pod project:"LTXiOSUtils" version:"s.version" desc:"tag desc"
# fastlane release_pod project:"LTXiOSUtils" version:"s.version"
# fastlane release_pod repo:"coder-star" project:"LTXiOSUtils" version:"s.version" desc:"tag desc"
