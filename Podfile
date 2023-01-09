# gem install cocoapods-binary
# plugin 'cocoapods-binary'


platform :ios, '12.0'
use_frameworks!
# keep_source_code_for_prebuilt_frameworks!
inhibit_all_warnings!

# ======================================GROUP PODS==========================================
def netalo_pods
  pod 'NetacomSDKs', :git => 'https://github.com/Netacom-NetAlo/NetaloSDKs-iOS', tag: '10.0.1'
  noti_netalo_pods
end

def noti_netalo_pods
  pod 'NotificationSDK', :git => 'https://github.com/Netacom-NetAlo/NotiSDKs-iOS', tag: '10.0.1'
  pod 'WebRTC', :git => 'https://github.com/Netacom-NetAlo/WebRTC-iOS', branch: 'main'
end

def resolver
  pod 'Resolver', :git => 'https://github.com/Netacom-NetAlo/Resolver-iOS', branch: 'main'
end

# ======================================TARGET PODS==========================================
def app_pods
  pod 'MessageKit', :git => 'https://github.com/Netacom-NetAlo/Messagekit-iOS'
  resolver
  netalo_pods

  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
end

target 'SDKDemo_SwiftUI' do
  app_pods
end

# ============================Notification Extension================================
def app_notification_pods
  resolver
  noti_netalo_pods
end

target 'NotificationExtension' do
  app_notification_pods
end

# Disable Bitcode because of JitsiMeetSDK
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['ARCHS'] = 'arm64 x86_64'
 	    config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end

