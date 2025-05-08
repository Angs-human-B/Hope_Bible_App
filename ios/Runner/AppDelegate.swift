import Flutter
import UIKit
import WidgetKit

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
      case "addHomeScreenWidget":
        if let args = call.arguments as? [String: Any] {
          self?.addHomeScreenWidget(data: args, result: result)
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
    let userDefaults = UserDefaults(suiteName: "group.com.hope.app")
    
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
    print("\n=== App: Saving to UserDefaults Start ===")
    
    // First, verify we can access the app group
    guard let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.hope.app") else {
        let error = "Failed to access app group container. Please verify app group configuration."
        print("Error: \(error)")
        print("=== App: Saving to UserDefaults End ===\n")
        result(FlutterError(code: "APP_GROUP_ERROR", message: error, details: nil))
        return
    }
    print("Successfully accessed app group container at: \(groupURL.path)")
    
    guard let userDefaults = UserDefaults(suiteName: "group.com.hope.app") else {
        let error = "Failed to initialize UserDefaults with suite name: group.com.hope.app"
        print("Error: \(error)")
        print("=== App: Saving to UserDefaults End ===\n")
        result(FlutterError(code: "USERDEFAULTS_ERROR", message: error, details: nil))
        return
    }
    print("Successfully initialized UserDefaults with app group")
    
    // Extract and validate the data
    let verse = data["verse"] as? String ?? ""
    let reference = data["reference"] as? String ?? ""
    let lastUpdate = data["lastUpdate"] as? String ?? ""
    
    if verse.isEmpty || reference.isEmpty {
        let error = "Invalid data: verse or reference is empty"
        print("Error: \(error)")
        print("verse: \(verse)")
        print("reference: \(reference)")
        print("=== App: Saving to UserDefaults End ===\n")
        result(FlutterError(code: "INVALID_DATA", message: error, details: nil))
        return
    }
    
    // Log the current state before saving
    print("\nCurrent UserDefaults contents:")
    for key in userDefaults.dictionaryRepresentation().keys {
        print("Key: \(key), Value: \(userDefaults.string(forKey: key) ?? "nil")")
    }
    
    print("\nSaving new values:")
    print("verse: \(verse)")
    print("reference: \(reference)")
    print("lastUpdate: \(lastUpdate)")
    
    // Save the data
    userDefaults.set(verse, forKey: "verse")
    userDefaults.set(reference, forKey: "reference")
    userDefaults.set(lastUpdate, forKey: "lastUpdate")
    
    // Force immediate synchronization
    let syncResult = userDefaults.synchronize()
    print("UserDefaults synchronization result: \(syncResult)")
    
    // Verify the data was saved
    print("\nVerifying saved data:")
    let savedVerse = userDefaults.string(forKey: "verse")
    let savedReference = userDefaults.string(forKey: "reference")
    let savedLastUpdate = userDefaults.string(forKey: "lastUpdate")
    
    print("verse: \(savedVerse ?? "nil")")
    print("reference: \(savedReference ?? "nil")")
    print("lastUpdate: \(savedLastUpdate ?? "nil")")
    
    if savedVerse != verse || savedReference != reference {
        print("Warning: Saved data verification failed!")
        print("Expected verse: \(verse), got: \(savedVerse ?? "nil")")
        print("Expected reference: \(reference), got: \(savedReference ?? "nil")")
    }
    
    // Reload widget
    if #available(iOS 14.0, *) {
        print("Reloading widget timelines")
        WidgetCenter.shared.reloadAllTimelines()
        
        // Also reload after a short delay to ensure the widget picks up the changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("Reloading widget timelines again after delay")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    print("=== App: Saving to UserDefaults End ===\n")
    result(true)
  }

  private func addHomeScreenWidget(data: [String: Any], result: @escaping FlutterResult) {
    // Reuse the same implementation as saveToAppGroup
    saveToAppGroup(data: data, result: result)
  }
}
