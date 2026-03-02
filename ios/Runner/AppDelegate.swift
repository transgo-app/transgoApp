import Flutter
import UIKit
import FirebaseCore
import GoogleSignIn

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // IMPORTANT: Call super FIRST to ensure the Flutter engine is fully
    // initialized before plugins try to register. This fixes cold-start
    // crashes (EXC_BAD_ACCESS in swift_getObjectType) where the engine
    // isn't ready when Swift plugins register their channels.
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    FirebaseApp.configure()
    
    // Configure Google Sign In
    if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
       let plist = NSDictionary(contentsOfFile: path),
       let clientId = plist["CLIENT_ID"] as? String {
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
    } else {
        print("Warning: GoogleService-Info.plist not found or CLIENT_ID missing. Google Sign In may not work.")
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    GeneratedPluginRegistrant.register(with: self)
    return result
  }
  
  // Handle URL callbacks for Google Sign In
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    if GIDSignIn.sharedInstance.handle(url) {
      return true
    }
    return super.application(app, open: url, options: options)
  }
}
