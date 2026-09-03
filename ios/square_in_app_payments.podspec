#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint square_in_app_payments.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'square_in_app_payments'
  s.version          = '1.6.7'
  s.summary          = 'A flutter plugin for Square In-App Payments SDK.'
  s.description      = <<-DESC
An open source Flutter plugin for calling Square's native In-App Payments SDK to take in-app payments.
                       DESC
  s.homepage         = 'https://github.com/square/in-app-payments-flutter-plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Square, Inc.' => 'flutter-team@squareup.com' }
  s.source           = { :path => '.' }
  s.source_files = 'square_in_app_payments/Sources/**/*.{h,m,swift}'
  s.public_header_files = 'square_in_app_payments/Sources/square_in_app_payments_objc/include/**/*.h'
  s.dependency 'Flutter'
  s.framework = 'SquareInAppPaymentsSDK'
  s.platform = :ios, '14.0'
  s.ios.deployment_target = '14.0'
  s.resource_bundle = { 'sqip_flutter_resource' => ['square_in_app_payments/Sources/square_in_app_payments_objc/Assets/**/*.{lproj,strings}'] }
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  if $sqipVersion
    s.dependency 'SquareInAppPaymentsSDK', $sqipVersion
    s.dependency 'SquareBuyerVerificationSDK', $sqipVersion
  else
    s.dependency 'SquareInAppPaymentsSDK', '1.6.7'
    s.dependency 'SquareBuyerVerificationSDK', '1.6.7'
  end
end
