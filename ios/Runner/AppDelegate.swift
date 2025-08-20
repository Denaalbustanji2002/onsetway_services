import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  // Pre-warmed Flutter engine
  lazy var flutterEngine = FlutterEngine(name: "main_engine")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // شغّل المحرّك مبكرًا لتقليل زمن أول إطار
    flutterEngine.run()

    // سجّل الملحقات للمحرّك الافتراضي وللمحرّك الدافئ
    GeneratedPluginRegistrant.register(with: self)
    GeneratedPluginRegistrant.register(with: flutterEngine)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
