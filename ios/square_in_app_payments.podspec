#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'square_in_app_payments'
  s.version          = '0.0.1'
  s.summary          = 'A flutter plugin for suqare in app payments.'
  s.description      = <<-DESC
A flutter plugin for suqare in app payments.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.vendored_framework = 'SquareInAppPaymentsSDK.framework'
  s.xcconfig         = { 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/../.symlinks/plugins/square_in_app_payments/ios"' }
  s.ios.deployment_target = '10.0'
  
end

