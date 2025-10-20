import SwiftUI
import GoogleMobileAds

public struct NativeAdsView: UIViewRepresentable {
    public typealias UIViewType = NativeAdView
    
    @State private var nativeAd: NativeAd
    private var style: NativeAdStyle
    
    init(nativeAd: NativeAd, style: NativeAdStyle) {
        self.nativeAd = nativeAd
        self.style = style
    }
    
    public func makeUIView(context: Context) -> NativeAdView {
        return style.view
    }
    
    func removeCurrentSizeConstraints(from mediaView: UIView) {
        mediaView.constraints.forEach { constraint in
            if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                mediaView.removeConstraint(constraint)
            }
        }
    }
    
    public func updateUIView(_ nativeAdView: NativeAdView, context: Context) {
        // headline require
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        
        // body
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        // icon
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = (nativeAd.icon == nil)
        
        // ratting
//        (nativeAdView.starRatingView as? UIImageView)?.image = nativeAd.starRattingImage
//        nativeAdView.starRatingView?.isHidden = (starRattingImage == nil)
        
        // store
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil
        
        // price
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil
        
        // advertiser
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = (nativeAd.advertiser == nil)
        
        // button
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
//        if style == .largeBanner, let body = nativeAd.body, body.count > 0 {
//            nativeAdView.callToActionView?.isHidden = true
//        }
        
        if let body = nativeAd.body, body.count > 0 {
            nativeAdView.callToActionView?.isHidden = true
        }
        
        // Associate the native ad view with the native ad object. This is required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
    }
}

// MARK: - Helper to present Interstitial Ad
public struct AdViewControllerRepresentable: UIViewControllerRepresentable {
    public var viewController = UIViewController()
    
    public init() {
        
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

