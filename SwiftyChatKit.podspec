#
# Be sure to run `pod lib lint SwiftyChatKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
# 1. new code update github, Release new version
# 2. local not code : pod repo add SwiftyChatKit  https://github.com/DanielZSY/SwiftyChatKit.git
#    local uodate code: cd ~/.cocoapods/repos/SwiftyChatKit. Then execute: pod repo update SwiftyChatKit
# 3. pod repo push SwiftyChatKit SwiftyChatKit.podspec --allow-warnings --sources='https://github.com/CocoaPods/Specs.git'
# 4. pod trunk push SwiftyChatKit.podspec --allow-warnings
# 5. pod install or pod update on you project execute


Pod::Spec.new do |s|
  s.name             = 'SwiftyChatKit'
  s.version          = '1.0.0'
  s.summary          = 'SwiftyChatKit'
  s.module_name      = 'SwiftyChatKit'
  s.description      = <<-DESC
  Common SwiftyChatKit
  DESC
  
  s.homepage         = 'https://github.com/DanielZSY'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DanielZSY' => 'DanielZSY@126.com' }
  s.source           = { :git => 'https://github.com/DanielZSY/SwiftyChatKit.git', :tag => s.version.to_s }
  
  s.swift_versions   = "5"
  s.ios.deployment_target = '10.0'
  s.platform     = :ios, '10.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  
  s.static_framework = true
  s.source_files     = 'SwiftyChatKit/Classes/**/*.{h,m,swift}'
  s.resources = ['SwiftyChatKit/Assets/**/*.strings']
  s.ios.resource_bundle = {
    'SwiftyChatKit' => 'SwiftyChatKit/Assets/Media.xcassets',
    'SwiftyChatCallKit' => 'SwiftyChatKit/Assets/Call.bundle',
    'SwiftyChatResourcesKit' => 'SwiftyChatKit/Assets/Resources.bundle',
    'SwiftyChatVideoKit' => 'SwiftyChatKit/Assets/Video.bundle'
  }
  
  s.frameworks   = 'UIKit', 'Foundation', 'CoreLocation', 'SystemConfiguration', 'CoreTelephony', 'Security', 'AVKit', 'MapKit'
  s.libraries    = 'z', 'sqlite3', 'c++'
  
  s.dependency 'OneSignal', '>= 2.11.2', '< 3.0'
  
  s.dependency 'BMPlayer'
  s.dependency 'SVGAPlayer'
  s.dependency 'SwipeCellKit'
  s.dependency 'SwiftBasicKit'
  s.dependency 'AlamofireNetworkActivityIndicator'
end
