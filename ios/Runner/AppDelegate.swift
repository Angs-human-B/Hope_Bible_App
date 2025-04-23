import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "HopeHomeWidget",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "getSharedData":
        self?.getSharedData(result: result)
      case "saveToAppGroup":
        if let args = call.arguments as? [String: Any] {
          self?.saveToAppGroup(data: args, result: result)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getSharedData(result: @escaping FlutterResult) {
    let userDefaults = UserDefaults(suiteName: "group.com.hope.widget")
    
    guard let verse = userDefaults?.string(forKey: "verse"),
          let reference = userDefaults?.string(forKey: "reference") else {
      result(FlutterError(code: "NO_DATA", message: "No data found in app group", details: nil))
      return
    }
    
    result([
      "verse": verse,
      "reference": reference,
      "lastUpdate": userDefaults?.string(forKey: "lastUpdate") ?? ""
    ])
  }

  private func saveToAppGroup(data: [String: Any], result: @escaping FlutterResult) {
    let userDefaults = UserDefaults(suiteName: "group.com.hope.widget")
    
    userDefaults?.set(data["verse"] as? String ?? "", forKey: "verse")
    userDefaults?.set(data["reference"] as? String ?? "", forKey: "reference")
    userDefaults?.set(data["lastUpdate"] as? String ?? "", forKey: "lastUpdate")
    userDefaults?.synchronize()
    
    result(true)
  }
}
