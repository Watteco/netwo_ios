platform :ios, '13.0'

target 'NetwO' do
  use_frameworks!

  pod 'MBProgressHUD'
  pod 'AAInfographics', :git => 'https://github.com/AAChartModel/AAChartKit-Swift.git'
end

post_install do |installer|
  deployment_target = '13.0'
  supported_platforms = 'iphoneos iphonesimulator'

  # 1) Force iOS 13 + réactive le simulateur sur TOUS les Pods
  installer.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
      config.build_settings['SUPPORTED_PLATFORMS'] = supported_platforms
    end
  end

  # 1bis) Force aussi sur ton projet (target app) si un xcconfig le bride
  installer.aggregate_targets.each do |aggregate_target|
    aggregate_target.user_project.native_targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['SUPPORTED_PLATFORMS'] = supported_platforms
      end
    end
  end

  # 2) Patch AAInfographics : Swift récent refuse @available(*, unavailable) sur stored properties
  aa_file = 'Pods/AAInfographics/AAInfographics/AAChartCreator/AAChartModel.swift'
  if File.exist?(aa_file)
    s = File.read(aa_file)
    s2 = s.gsub('@available(*, unavailable', '@available(*, deprecated')
    if s2 != s
      File.write(aa_file, s2)
      puts "Patched AAInfographics: unavailable -> deprecated in AAChartModel.swift"
    end
  else
    puts "!! AAInfographics file not found at: #{aa_file}"
  end
end
