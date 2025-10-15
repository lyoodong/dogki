import Foundation

enum ServiceURL {
    static var store: String {
        "itms-apps://itunes.apple.com/app/\(AppInfo.storeID)"
    }
    
    static var storeReview: String {
        "https://apps.apple.com/app/id\(AppInfo.storeID)?action=write-review"
    }
    
    static var term: String {
        "https://bdnmco.github.io/dokgi-term/"
    }
    
    static var privacy: String {
        "https://bdnmco.github.io/dokgi-privacy/"
    }
}
