import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TODO
    GMSServices.provideAPIKey("AIzaSyA5RP9GahtKs4-21xiyxOJ14ziTytU26v4")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
