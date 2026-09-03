import Flutter

// Under Swift Package Manager the Objective-C bridge is a separate module
// (`square_in_app_payments_objc`) and must be imported explicitly. SPM defines
// the `SWIFT_PACKAGE` flag automatically; CocoaPods does not. Under CocoaPods
// every source file compiles into a single `square_in_app_payments` module, so
// `FSQIPPlugin` is already visible here (its header is in `public_header_files`)
// and importing the non-existent module would fail to compile.
#if SWIFT_PACKAGE
import square_in_app_payments_objc
#endif

/// Public Flutter entry point for the Square In-App Payments plugin.
///
/// This is the class Flutter looks up (see `pluginClass` in `pubspec.yaml`).
/// Swift Package Manager does not allow mixing Swift and Objective-C in a single
/// target, so the whole bridge lives in the `square_in_app_payments_objc`
/// Objective-C target. This
/// thin Swift shim just forwards plugin registration to `FSQIPPlugin`, which owns
/// the method channel and dispatches every call to the Square SDK modules.
public class SquareInAppPaymentsFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    FSQIPPlugin.register(with: registrar)
  }
}
