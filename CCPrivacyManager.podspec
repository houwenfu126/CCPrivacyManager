Pod::Spec.new do |s|
  s.name         = "CCPrivacyManager" # 项目名称
  s.version      = "1.0.0"        # 版本号
  s.license      = "MIT"          # 开源证书
  s.summary      = "CCPrivacyManager" # 项目简介

  s.homepage     = "https://github.com/houwenfu126/CCPrivacyManager" #主页
  s.source       = { :git => "https://github.com/houwenfu126/CCPrivacyManager.git", :tag => "#{s.version}" }#仓库地址，不能用SSH地址
  s.source_files = "CCPrivacyManager/*.{h,m}" # 代码的位置
  s.requires_arc = true # 是否启用ARC
  s.platform     = :ios, "9.3" #平台及支持的最低版本
  s.frameworks   = "UIKit", "Foundation" #支持的框架
  # s.dependency   = "AFNetworking" # 依赖库
  
  # User
  s.author             = { "houwenfu" => "houwenfu@126.com" } # 作者信息
  s.social_media_url   = "https://github.com/houwenfu126" # 个人主页

end
