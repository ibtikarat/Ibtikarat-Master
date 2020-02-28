# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'Matajer' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TammwelV3
pod 'Alamofire', '~> 5.0.0-rc.2'
pod 'SKActivityIndicatorView' , :git => 'https://github.com/SachK13/SKActivityIndicatorView.git', :commit => 'bb0a954'

pod 'PopupDialog', '~> 1.1'
pod 'IQKeyboardManagerSwift'

pod 'SDWebImage' 

pod 'MOLH', '~> 1.0'

pod 'ImageSlideshow', '~> 1.8'
pod 'ImageSlideshow/SDWebImage'

pod 'Segmentio'

pod 'Cosmos', '~> 19.0'
pod 'RealmSwift'
pod "BSImagePicker", "~> 2.8"

# add the Firebase pod for Google Analytics
pod 'Firebase/Analytics'
pod 'Firebase/Messaging'

pod 'SVProgressHUD'
pod 'CHIPageControl', '~> 0.1.3'
pod 'NotificationBannerSwift', '~> 3.0.0'

pod 'loady'

pod 'GoogleMaps'
pod 'GooglePlaces'

pod 'ParallaxHeader', '~> 2.0.0'
pod "MXParallaxHeader"


pod 'goSellSDK'



end

#
#post_install do |installer|
#  installer.pods_project.build_configurations.each do |config|
#    config.build_settings.delete('CODE_SIGNING_ALLOWED')
#    config.build_settings.delete('CODE_SIGNING_REQUIRED')
#  end
#end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end
