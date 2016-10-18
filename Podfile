# Uncomment this line to define a global platform for your project
# source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'TrackTV' do
  use_frameworks!

  # Pods for RedShirt
   pod 'SQLite.swift', :git => 'https://github.com/stephencelis/SQLite.swift.git'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
