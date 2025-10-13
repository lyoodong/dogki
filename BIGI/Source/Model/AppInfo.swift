import SwiftUI

enum AppInfo {
    static var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    static var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    static var versionWithBuild: String {
        "\(appVersion) (\(buildNumber))"
    }
    
    static var osVersion: String {
        "\(UIDevice.current.systemVersion)"
    }
    
    static var storeUrl: String {
        "itms-apps://itunes.apple.com/app/7HDHR2SNR7"
    }
    
    static var emailFrame: EmailFrame {
        return .init(
            recipients: ["lyoodong@naver.com"],
            subject: "Report: ",
            body: """
            안녕하세요,
            
            App Version: \(appVersion)
            OS Version: \(osVersion)
            """
        )
    }
}


