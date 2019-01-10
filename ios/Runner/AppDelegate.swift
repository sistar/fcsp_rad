import UIKit
import Flutter
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    AppSyncPlugin.register(with: registrar(forPlugin: "AppSyncPlugin"))
    GMSServices.provideAPIKey("AIzaSyAJub8TcUbZQxhfHW1wVe59mmYI2bOqJ1o")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
