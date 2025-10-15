import Foundation

enum ServiceURL {
    static var store: String {
        "itms-apps://itunes.apple.com/app/\(AppInfo.storeID)"
    }
    
    static var term: String {
        "https://bdnmco.github.io/dokgi-term/"
    }
    
    static var privacy: String {
        "https://bdnmco.github.io/dokgi-privacy/"
    }
}
