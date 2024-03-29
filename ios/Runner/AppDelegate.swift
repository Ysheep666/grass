import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    MethodFlutterPlugin.register(with: self.registrar(forPlugin: "MethodFlutterPlugin"))
    WidgetFlutterPlugin.register(with: self.registrar(forPlugin: "WidgetFlutterPlugin"))
    UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消"
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
