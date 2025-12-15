# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

target 'clock2go2020' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for clock2go2020
  pod 'BackgroundGeolocation', :path => 'background-geolocation-lt-1.4.0/ios/BackgroundGeolocation.podspec'
  pod 'GoogleMaps', '3.6.0'
  pod 'GooglePlaces', '3.6.0'
  pod 'Alamofire', '< 5.0'	
  pod 'SwiftyJSON'
  pod 'OneSignal', '>= 2.11.2', '< 3.0'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod "youtube-ios-player-helper"
  pod 'ReachabilitySwift'
  pod 'AnyCodable-FlightSchool', '~> 0.3.0'
#  pod 'IQKeyboardManagerSwift'
  pod 'Siren'
  
end

target 'OneSignalNotificationServiceExtension' do
  use_frameworks!

  pod 'OneSignal', '>= 2.11.2', '< 3.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = 'arm64'
    end
    
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
    
    target.build_configurations.each do |config|
      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
        xcconfig_path = config.base_configuration_reference.real_path
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
    
  end
end
