import SwiftUI
import GoogleMobileAds

public class NativeAdService: NSObject, ObservableObject, NativeAdLoaderDelegate {
    @Published private(set) var cachedAds: [NativeAd] = []
    @Published public var isLoading: Bool = false
    private var adLoader: AdLoader!
    private var adUnitID: String
    private var lastRequestTime: Date?
    public var requestInterval: Int
    private var numberOfAds: Int
    private static var lastRequestTimes: [String: Date] = [:]

    init(adUnitID: String, requestInterval: Int = 1 * 60, numberOfAds: Int = 1) {
        self.adUnitID = adUnitID
        self.requestInterval = requestInterval
        self.numberOfAds = numberOfAds
        self.lastRequestTime = NativeAdService.lastRequestTimes[adUnitID]
    }

    public func refreshAd() {
        let now = Date()

        if !cachedAds.isEmpty, let lastRequest = lastRequestTime, now.timeIntervalSince(lastRequest) < Double(requestInterval) {
            print("The last request was made less than \(requestInterval / 60) minutes ago. New request is canceled.")
            return
        }

        guard !isLoading else {
            print("Previous request is still loading, new request is canceled.")
            return
        }

        isLoading = true
        lastRequestTime = now
        NativeAdService.lastRequestTimes[adUnitID] = now

        let adViewOptions = NativeAdViewAdOptions()
        adViewOptions.preferredAdChoicesPosition = .topRightCorner
        
        let multipleAdsAdLoaderOptions = MultipleAdsAdLoaderOptions()
        multipleAdsAdLoaderOptions.numberOfAds = numberOfAds
        
        adLoader = AdLoader(adUnitID: adUnitID, rootViewController: nil, adTypes: [.native], options: [adViewOptions, multipleAdsAdLoaderOptions])
        adLoader.delegate = self
        adLoader.load(Request())
    }

    public func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        nativeAd.delegate = self
        self.isLoading = false
        self.cachedAds.append(nativeAd)
        nativeAd.mediaContent.videoController.delegate = self
    }
    
    public func adLoaderDidFinishLoading(_ adLoader: AdLoader) {
        print("\(adLoader) adLoaderDidFinishLoading")
    }

    public func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
        self.isLoading = false
    }
}

extension NativeAdService: VideoControllerDelegate {
    // GADVideoControllerDelegate methods
    public func videoControllerDidPlayVideo(_ videoController: VideoController) {
        // Implement this method to receive a notification when the video controller
        // begins playing the ad.
    }

    public func videoControllerDidPauseVideo(_ videoController: VideoController) {
        // Implement this method to receive a notification when the video controller
        // pauses the ad.
    }

    public func videoControllerDidEndVideoPlayback(_ videoController: VideoController) {
        // Implement this method to receive a notification when the video controller
        // stops playing the ad.
    }

    public func videoControllerDidMuteVideo(_ videoController: VideoController) {
        // Implement this method to receive a notification when the video controller
        // mutes the ad.
    }

    public func videoControllerDidUnmuteVideo(_ videoController: VideoController) {
        // Implement this method to receive a notification when the video controller
        // unmutes the ad.
    }
}

// MARK: - NativeAdDelegate
extension NativeAdService: NativeAdDelegate {
    public func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        print("\(#function) called")
    }

    public func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        print("\(#function) called")
    }

    public func nativeAdWillPresentScreen(_ nativeAd: NativeAd) {
        print("\(#function) called")
    }

    public func nativeAdWillDismissScreen(_ nativeAd: NativeAd) {
        print("\(#function) called")
    }

    public func nativeAdDidDismissScreen(_ nativeAd: NativeAd) {
        print("\(#function) called")
    }
}
