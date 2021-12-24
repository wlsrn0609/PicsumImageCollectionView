# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PicsumImageCollectionView' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PicsumImageCollectionView

  platform :ios, '11.0'
  
  #https://github.com/SnapKit/SnapKit
  pod 'SnapKit', '~> 5.0.0'
  
  #https://github.com/jdg/MBProgressHUD
  pod 'MBProgressHUD', '~> 1.2.0'

  ##https://github.com/devxoul/Toaster
  pod 'Toaster', '2.3.0'

  #https://github.com/RxSwiftCommunity/NSObject-Rx
  pod 'NSObject+Rx', '5.1.0'

  #https://github.com/ReactiveX/RxSwift
  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'
  pod 'RxDataSources', '4.0.1'

  
end
