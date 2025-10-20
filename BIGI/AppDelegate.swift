import SwiftUI
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupSDK()
        return true
    }
    
    private func setupSDK() {
        FirebaseApp.configure()
        MobileAds.shared.start()
    }
}
