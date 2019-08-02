Pod::Spec.new do |s|
    s.name         = "LTXiOSUtils"
    s.version      = "1.0.0"
    s.ios.deployment_target = '10.0'
    s.summary      = "一些工具类以及类扩展"
    s.homepage     = "https://github.com/Coder-Star"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "CoderStar" => "1340529758@qq.com" }
    s.source       = { :git => "https://github.com/Coder-Star/LTXiOSUtils.git", :tag => s.version }
    s.source_files = "Sources/*"
    s.requires_arc = true
    if s.respond_to? 'swift_version'
      s.swift_version = "4.2"
    end
end