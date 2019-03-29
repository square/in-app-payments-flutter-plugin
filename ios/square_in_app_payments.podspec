#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'square_in_app_payments'
  s.version          = '1.1.0'
  s.summary          = 'A flutter plugin for Square In-App Payments SDK.'
  s.description      = <<-DESC
An open source Flutter plugin for calling Square's native In-App Payments SDK to take in-app payments.
                       DESC
  s.homepage         = 'https://github.com/square/in-app-payments-flutter-plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Square, Inc.' => 'flutter-team@squareup.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.framework = 'SquareInAppPaymentsSDK'
  s.xcconfig         = { 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/../.symlinks/plugins/square_in_app_payments/ios"' }
  s.ios.deployment_target = '11.0'
  s.resource_bundle = { "sqip_flutter_resource" => ["Assets/*.lproj/*.strings"] }

  if $sqipVersion
    s.dependency 'SquareInAppPaymentsSDK', $sqipVersion
  else
    s.dependency 'SquareInAppPaymentsSDK', '1.1.1'
  end
end

