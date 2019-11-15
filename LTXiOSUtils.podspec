Pod::Spec.new do |s|
    s.name         = "LTXiOSUtils"
    s.version      = "1.0.2"
    s.platform     = :ios, "10.0" #iOS平台最低版本 10.0
    s.summary      = "通用工具类以及组件的整合、封装"
    s.homepage     = "https://github.com/Coder-Star"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "CoderStar" => "1340529758@qq.com" }
#    s.source       = { :git => "https://github.com/Coder-Star/LTXiOSUtils.git", :tag => s.version }
    s.source       = { :git => 'local', :tag => s.version}
    s.requires_arc = true
    s.swift_version = "4.2"
#    s.resources     = 'Source/Resource/**/*'

    s.subspec 'Utils' do |ss1|
      ss1.source_files = 'LTXiOSUtils/Classes/Utils/*.swift'
    end

#    s.subspec 'Views' do |ss2|
#      ss2.source_files = 'Source/Classes/Views/*.swift'
#    end


end
