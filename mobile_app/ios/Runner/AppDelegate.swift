import Flutter
import UIKit
import PassKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Set up PassKit method channel
    if let controller = window?.rootViewController as? FlutterViewController {
      let passChannel = FlutterMethodChannel(name: "com.sdb.wallet/passkit", binaryMessenger: controller.binaryMessenger)
      
      passChannel.setMethodCallHandler { [weak self] (call, result) in
        switch call.method {
        case "canAddPasses":
          result(PKAddPassesViewController.canAddPasses())
          
        case "addPass":
          guard let args = call.arguments as? [String: Any],
                let passData = args["passData"] as? FlutterStandardTypedData else {
            result(FlutterError(code: "INVALID_ARGS", message: "Pass data required", details: nil))
            return
          }
          self?.addPassToWallet(data: passData.data, result: result)
          
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func addPassToWallet(data: Data, result: @escaping FlutterResult) {
    do {
      let pass = try PKPass(data: data)
      
      // Check if pass already exists
      let passLib = PKPassLibrary()
      if passLib.containsPass(pass) {
        result(["status": "already_added", "message": "Card already in Apple Wallet"])
        return
      }
      
      guard let addController = PKAddPassesViewController(pass: pass) else {
        result(FlutterError(code: "UI_ERROR", message: "Cannot create pass dialog", details: nil))
        return
      }
      
      // Present the add pass dialog
      if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
          topVC = presented
        }
        
        addController.delegate = self
        topVC.present(addController, animated: true) {
          result(["status": "presented", "message": "Pass dialog shown"])
        }
      } else {
        result(FlutterError(code: "UI_ERROR", message: "No root view controller", details: nil))
      }
    } catch {
      result(FlutterError(code: "PASS_ERROR", message: "Invalid pass: \(error.localizedDescription)", details: "\(error)"))
    }
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

extension AppDelegate: PKAddPassesViewControllerDelegate {
  func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
    controller.dismiss(animated: true)
  }
}
