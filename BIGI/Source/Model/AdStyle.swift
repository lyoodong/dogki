import Foundation
import GoogleMobileAds

enum NativeAdStyle {
    case listItem
}

extension NativeAdStyle {
    var adUnitID: String {
        switch self {
        case .listItem:
            return "ca-app-pub-7762348548274602/4131115060"
        }
    }
    
    var view: NativeAdView {
        switch self {
        case .listItem:
            return NativeListItemView()
        }
    }
}
