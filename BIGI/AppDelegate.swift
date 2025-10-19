import SwiftUI
import FirebaseCore
import GoogleMobileAds


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        MobileAds.shared.start()
//        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = [ "410a69826223a2ad58ebf914fb5e8c8e" ]

        return true
    }
}
